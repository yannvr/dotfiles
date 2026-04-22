-- Session picker for persisted.nvim
-- Sessions are stored as .vim files; filename encodes the CWD with % as separator.
local M = {}

local sessions_dir = vim.fn.stdpath("data") .. "/sessions"
local meta_path    = vim.fn.stdpath("data") .. "/sessions_meta.json"

-- ── helpers ────────────────────────────────────────────────────────────────

local function get_json()
  return vim.json or { decode = vim.fn.json_decode, encode = vim.fn.json_encode }
end

local function load_meta()
  if vim.fn.filereadable(meta_path) == 1 then
    local ok, data = pcall(get_json().decode, table.concat(vim.fn.readfile(meta_path), "\n"))
    if ok and type(data) == "table" then return data end
  end
  return {}
end

local function save_meta(meta)
  local ok, encoded = pcall(get_json().encode, meta or {})
  if ok then
    vim.fn.writefile({ encoded }, meta_path)
  end
end

-- Decode %Users%yannvr%foo → /Users/yannvr/foo
local function decode_name(name)
  return ("/" .. name):gsub("%%", "/")
end

-- Encode /Users/yannvr/foo → %Users%yannvr%foo
local function encode_path(path)
  return path:gsub("^/", ""):gsub("/", "%%")
end

local function session_path(name)
  return sessions_dir .. "/" .. name .. ".vim"
end

local function list_sessions()
  local files = vim.fn.globpath(sessions_dir, "*.vim", false, true)
  local meta  = load_meta()
  local out   = {}
  for _, f in ipairs(files) do
    local name = vim.fn.fnamemodify(f, ":t:r")  -- strip dir + .vim
    local cwd  = decode_name(name)
    local mtime = (vim.loop.fs_stat(f) or {}).mtime
    mtime = mtime and (mtime.sec or 0) or 0
    local m = meta[name] or {}
    local git_branch = nil
    if vim.fn.isdirectory(cwd) == 1 then
      local res = vim.fn.systemlist({ "git", "-C", cwd, "rev-parse", "--abbrev-ref", "HEAD" })
      if vim.v.shell_error == 0 and res[1] then git_branch = res[1] end
    end
    table.insert(out, {
      name         = name,
      path         = f,
      cwd          = cwd,
      mtime        = mtime,
      favorite     = m.favorite or false,
      last_accessed = m.last_accessed or 0,
      git_branch   = git_branch,
    })
  end
  table.sort(out, function(a, b)
    if a.favorite ~= b.favorite then return a.favorite end
    return a.mtime > b.mtime
  end)
  return out, meta
end

local function display(item)
  local star  = item.favorite and "★ " or "  "
  local label = vim.fn.fnamemodify(item.cwd, ":~")
  local branch = item.git_branch and (" [" .. item.git_branch .. "]") or ""
  return star .. label .. branch
end

local function preview_lines(item)
  local lines = {}
  local star = item.favorite and "★" or "☆"
  table.insert(lines, star .. "  " .. vim.fn.fnamemodify(item.cwd, ":~"))
  table.insert(lines, "")
  table.insert(lines, "CWD:   " .. item.cwd)
  table.insert(lines, "File:  " .. item.path)
  table.insert(lines, "Saved: " .. os.date("%Y-%m-%d  %H:%M:%S", item.mtime))
  if item.git_branch then
    table.insert(lines, "Branch: " .. item.git_branch)
  end
  table.insert(lines, "")
  table.insert(lines, "Keys:")
  table.insert(lines, "  <CR>   load session")
  table.insert(lines, "  s      save / update current session")
  table.insert(lines, "  S      save as new name")
  table.insert(lines, "  r      rename session")
  table.insert(lines, "  d      delete session")
  table.insert(lines, "  f      toggle favourite")
  table.insert(lines, "  R      refresh list")
  table.insert(lines, "  q / <Esc>  quit")
  return lines
end

local function update_accessed(meta, name)
  meta[name] = meta[name] or {}
  meta[name].last_accessed = os.time()
  save_meta(meta)
end

-- ── picker ──────────────────────────────────────────────────────────────────

function M.open_picker()
  local ok, telescope = pcall(require, "telescope")
  if not ok then
    vim.notify("sessions.picker: telescope.nvim not available", vim.log.levels.ERROR)
    return
  end

  local pickers      = require("telescope.pickers")
  local finders      = require("telescope.finders")
  local conf         = require("telescope.config").values
  local actions      = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local previewers   = require("telescope.previewers")

  local sessions, meta = list_sessions()

  local function make_finder()
    return finders.new_table({
      results = list_sessions(),
      entry_maker = function(item)
        return {
          value   = item,
          display = display(item),
          -- fav first (0/1), then most-recent first (invert mtime so higher = earlier)
          ordinal = (item.favorite and "0" or "1") .. string.format("%020d", 9999999999 - item.mtime) .. display(item),
        }
      end,
    })
  end

  local previewer = previewers.new_buffer_previewer({
    title = "Session info",
    define_preview = function(self, entry)
      if not entry or not entry.value then return end
      vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, preview_lines(entry.value))
    end,
  })

  pickers.new({}, {
    prompt_title = "Sessions",
    finder       = make_finder(),
    sorter       = conf.generic_sorter({}),
    previewer    = previewer,

    attach_mappings = function(prompt_bufnr, map)
      local function entry()
        local e = action_state.get_selected_entry()
        return e and e.value or nil
      end

      -- Load
      local function act_load()
        local e = entry()
        if not e then return end
        actions.close(prompt_bufnr)
        vim.cmd("silent! %bdelete")
        vim.cmd("source " .. vim.fn.fnameescape(e.path))
        update_accessed(meta, e.name)
        vim.notify("Session loaded: " .. vim.fn.fnamemodify(e.cwd, ":~"), vim.log.levels.INFO)
      end

      -- Save / update (overwrite the highlighted session with the current state)
      local function act_save()
        local e = entry() or {}
        local path = e.path or session_path(encode_path(vim.fn.getcwd()))
        vim.cmd("mksession! " .. vim.fn.fnameescape(path))
        if e.name then update_accessed(meta, e.name) end
        vim.notify("Session saved: " .. vim.fn.fnamemodify(path, ":t:r"), vim.log.levels.INFO)
        -- refresh without closing
        local picker = action_state.get_current_picker(prompt_bufnr)
        picker:refresh(make_finder(), { reset_prompt = false })
      end

      -- Save as new name
      local function act_save_as()
        actions.close(prompt_bufnr)
        local name = vim.fn.input("Save session as (dir name): ", "")
        if name == "" then return end
        local encoded = encode_path(vim.fn.expand(name))
        local path = session_path(encoded)
        vim.cmd("mksession! " .. vim.fn.fnameescape(path))
        update_accessed(meta, encoded)
        vim.notify("Session saved: " .. name, vim.log.levels.INFO)
      end

      -- Rename
      local function act_rename()
        local e = entry()
        if not e then return end
        actions.close(prompt_bufnr)
        local newname = vim.fn.input("Rename to (dir path): ", e.cwd)
        if newname == "" or newname == e.cwd then return end
        local new_encoded = encode_path(newname)
        local new_path = session_path(new_encoded)
        vim.loop.fs_rename(e.path, new_path)
        if meta[e.name] then
          meta[new_encoded] = meta[e.name]
          meta[e.name] = nil
          save_meta(meta)
        end
        vim.notify("Renamed to: " .. newname, vim.log.levels.INFO)
      end

      -- Delete
      local function act_delete()
        local e = entry()
        if not e then return end
        local confirm = vim.fn.input("Delete session '" .. vim.fn.fnamemodify(e.cwd, ":~") .. "'? [y/N]: ")
        if confirm:lower() ~= "y" then return end
        vim.fn.delete(e.path)
        if meta[e.name] then meta[e.name] = nil; save_meta(meta) end
        vim.notify("Deleted: " .. e.name, vim.log.levels.INFO)
        local picker = action_state.get_current_picker(prompt_bufnr)
        picker:refresh(make_finder(), { reset_prompt = false })
      end

      -- Favourite toggle
      local function act_favourite()
        local e = entry()
        if not e then return end
        meta = load_meta()
        meta[e.name] = meta[e.name] or {}
        meta[e.name].favorite = not meta[e.name].favorite
        save_meta(meta)
        local picker = action_state.get_current_picker(prompt_bufnr)
        picker:refresh(make_finder(), { reset_prompt = false })
      end

      -- Refresh
      local function act_refresh()
        local picker = action_state.get_current_picker(prompt_bufnr)
        picker:refresh(make_finder(), { reset_prompt = false })
      end

      map("i", "<CR>", act_load)
      map("n", "<CR>", act_load)
      map("i", "s",    act_save)
      map("n", "s",    act_save)
      map("i", "S",    act_save_as)
      map("n", "S",    act_save_as)
      map("i", "r",    act_rename)
      map("n", "r",    act_rename)
      map("i", "d",    act_delete)
      map("n", "d",    act_delete)
      map("i", "f",    act_favourite)
      map("n", "f",    act_favourite)
      map("i", "R",    act_refresh)
      map("n", "R",    act_refresh)
      return true
    end,
  }):find()
end

function M.save_current()
  local cwd     = vim.fn.getcwd()
  local encoded = encode_path(cwd)
  local path    = session_path(encoded)
  vim.cmd("mksession! " .. vim.fn.fnameescape(path))
  local meta = load_meta()
  update_accessed(meta, encoded)
  vim.notify("Session saved: " .. vim.fn.fnamemodify(cwd, ":~"), vim.log.levels.INFO)
end

return M
