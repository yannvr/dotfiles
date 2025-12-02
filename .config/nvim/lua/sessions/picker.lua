local M = {}

local Path = require("plenary.path")
local Job = require("plenary.job")

local function get_json()
  if vim.json and vim.json.decode and vim.json.encode then
    return vim.json
  end
  return {
    decode = vim.fn.json_decode,
    encode = vim.fn.json_encode,
  }
end

local function get_sessions_dir()
  -- possession default directory
  return vim.fn.stdpath("data") .. "/possession"
end

local function percent_decode(str)
  if not str then return str end
  -- decode %XX sequences
  local s = str:gsub("%%(%x%x)", function(hex)
    local n = tonumber(hex, 16)
    return n and string.char(n) or ("%" .. hex)
  end)
  return s
end

local function get_meta_path()
  return vim.fn.stdpath("data") .. "/sessions_meta.json"
end

local function load_meta()
  local meta_path = get_meta_path()
  if vim.fn.filereadable(meta_path) == 1 then
    local ok, decoded = pcall(get_json().decode, table.concat(vim.fn.readfile(meta_path), "\n"))
    if ok and type(decoded) == "table" then
      return decoded
    end
  end
  return {}
end

local function save_meta(meta)
  local encoded = get_json().encode(meta or {})
  Path:new(get_meta_path()):write(encoded, "w")
end

local function read_file(path)
  local ok, data = pcall(function()
    return table.concat(vim.fn.readfile(path), "\n")
  end)
  if ok then
    return data
  end
  return nil
end

local function stat_mtime(path)
  local st = vim.loop.fs_stat(path)
  if st and st.mtime then
    return st.mtime.sec or st.mtime.nsec or 0
  end
  return 0
end

local function parse_session(path)
  local data = read_file(path)
  if not data or data == "" then
    return {}
  end
  local ok, json = pcall(get_json().decode, data)
  if not ok or type(json) ~= "table" then
    return {}
  end
  -- Best-effort extraction: cwd, last file from buffers/windows if present
  local cwd = json.cwd or (json.data and json.data.cwd) or json.working_directory
  local last_file = nil
  if json.buffers and type(json.buffers) == "table" then
    for _, b in ipairs(json.buffers) do
      if b.name then
        last_file = b.name
      end
    end
  end
  if not last_file and json.data and json.data.buffers then
    for _, b in ipairs(json.data.buffers) do
      if b.name then
        last_file = b.name
      end
    end
  end
  return {
    cwd = cwd,
    last_file = last_file,
  }
end

local function git_info(cwd)
  if not cwd or vim.fn.isdirectory(cwd) == 0 then
    return nil
  end
  if vim.fn.isdirectory(cwd .. "/.git") == 0 then
    return nil
  end
  local function run_git(args)
    local ok, result = pcall(function()
      return Job:new({ command = "git", args = vim.list_extend({ "-C", cwd }, args) }):sync()
    end)
    if ok and result and #result > 0 then
      return result
    end
    return nil
  end
  local branch = run_git({ "rev-parse", "--abbrev-ref", "HEAD" })
  if branch then branch = branch[1] end
  local status = run_git({ "status", "--porcelain" }) or {}
  local added, modified, deleted = 0, 0, 0
  for _, line in ipairs(status) do
    local c = line:sub(1, 2)
    if c:match("A") then added = added + 1 end
    if c:match("M") then modified = modified + 1 end
    if c:match("D") then deleted = deleted + 1 end
  end
  local ahead, behind
  local lr = run_git({ "rev-list", "--left-right", "--count", "@{upstream}...HEAD" })
  if lr and lr[1] then
    local a, b = lr[1]:match("^(%d+)%s+(%d+)$")
    ahead, behind = tonumber(b), tonumber(a) -- left=upstream, right=HEAD
  end
  return {
    branch = branch,
    added = added,
    modified = modified,
    deleted = deleted,
    ahead = ahead,
    behind = behind,
  }
end

local function list_sessions()
  local dir = get_sessions_dir()
  local files = vim.fn.globpath(dir, "*", false, true)
  local meta = load_meta()
  local sessions = {}
  for _, f in ipairs(files) do
    if vim.fn.isdirectory(f) == 0 then
      local name = vim.fn.fnamemodify(f, ":t"):gsub("%.json$", "")
      local display_name = percent_decode(name)
      local info = parse_session(f)
      local gi = git_info(info.cwd)
      local mtime = stat_mtime(f)
      local m = meta[name] or {}
      table.insert(sessions, {
        name = name,
        display_name = display_name,
        path = f,
        mtime = mtime,
        cwd = info.cwd,
        last_file = info.last_file,
        favorite = m.favorite or false,
        last_accessed = m.last_accessed or 0,
        git = gi,
      })
    end
  end
  table.sort(sessions, function(a, b)
    if a.favorite ~= b.favorite then
      return a.favorite
    end
    local la = a.last_accessed ~= 0 and a.last_accessed or a.mtime
    local lb = b.last_accessed ~= 0 and b.last_accessed or b.mtime
    return la > lb
  end)
  return sessions, meta
end

local function update_last_accessed(meta, name)
  meta[name] = meta[name] or {}
  meta[name].last_accessed = os.time()
  save_meta(meta)
end

local function toggle_favorite(meta, name)
  meta[name] = meta[name] or {}
  meta[name].favorite = not not (not meta[name].favorite)
  save_meta(meta)
  return meta[name].favorite
end

local function preview_lines(entry)
  local lines = {}
  local star = entry.favorite and "★" or "☆"
  table.insert(lines, string.format("%s %s", star, entry.display_name or entry.name))
  table.insert(lines, "")
  table.insert(lines, "Path: " .. entry.path)
  if entry.cwd then
    table.insert(lines, "CWD:  " .. entry.cwd)
  end
  table.insert(lines, "Saved: " .. os.date("%Y-%m-%d %H:%M:%S", entry.mtime or 0))
  if entry.last_file then
    table.insert(lines, "Last file: " .. entry.last_file)
  end
  if entry.git then
    local gi = entry.git
    table.insert(lines, "")
    table.insert(lines, "Git:")
    table.insert(lines, "  Branch: " .. (gi.branch or "?"))
    table.insert(lines, string.format("  Changes: +%d ~%d -%d", gi.added or 0, gi.modified or 0, gi.deleted or 0))
    if gi.ahead or gi.behind then
      table.insert(lines, string.format("  Ahead/Behind: %s/%s", gi.ahead or 0, gi.behind or 0))
    end
  end
  table.insert(lines, "")
  table.insert(lines, "Actions: <CR> load   s save/update   r rename   d delete   f favorite   R refresh   q quit")
  return lines
end

local function refresh_picker(prompt_bufnr)
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
  -- Reload sessions and metadata to ensure fresh data
  local sessions, _ = list_sessions()
  picker:refresh(finders.new_table({
    results = sessions,
    entry_maker = function(item)
      local star = item.favorite and "★" or "☆"
      return {
        value = item,
        display = string.format("%s %s", star, item.display_name or item.name),
        ordinal = (item.favorite and "1" or "0") .. " " .. (item.last_accessed or 0) .. " " .. (item.display_name or item.name),
      }
    end,
  }), { reset_prompt = false })
end

function M.open_picker()
  local pickers = require("telescope.pickers")
  local finders = require("telescope.finders")
  local conf = require("telescope.config").values
  local previewers = require("telescope.previewers")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")

  local sessions, meta = list_sessions()

  local previewer = previewers.new_buffer_previewer({
    title = "Session Details",
    define_preview = function(self, entry, _)
      if not entry or not entry.value then
        return
      end
      local bufnr = self.state.bufnr
      vim.api.nvim_buf_set_option(bufnr, "filetype", "markdown")
      local lines = preview_lines(entry.value)
      vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, lines)
    end,
  })

  pickers.new({}, {
    prompt_title = "Sessions",
    finder = finders.new_table({
      results = sessions,
      entry_maker = function(item)
        local star = item.favorite and "★" or "☆"
        return {
          value = item,
          display = string.format("%s %s", star, item.display_name or item.name),
          ordinal = (item.favorite and "1" or "0") .. " " .. (item.last_accessed or 0) .. " " .. (item.display_name or item.name),
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    previewer = previewer,
    attach_mappings = function(prompt_bufnr, map)
      local function get_entry()
        local entry = action_state.get_selected_entry()
        return entry and entry.value or nil
      end

      local function act_load()
        local e = get_entry()
        if not e then return end
        actions.close(prompt_bufnr)
        pcall(vim.cmd, "silent! PossessionLoad " .. vim.fn.fnameescape(e.name))
        update_last_accessed(meta, e.name)
      end

      local function act_save()
        local e = get_entry() or {}
        local name = vim.fn.input("Save session as: ", e.name or "", "file")
        if name and name ~= "" then
          pcall(vim.cmd, "silent! PossessionSave " .. vim.fn.fnameescape(name))
          update_last_accessed(meta, name)
          refresh_picker(prompt_bufnr)
        end
      end

      local function act_rename()
        local e = get_entry()
        if not e then return end
        local newname = vim.fn.input("Rename to: ", e.name, "file")
        if newname and newname ~= "" and newname ~= e.name then
          pcall(vim.cmd, "silent! PossessionRename " .. vim.fn.fnameescape(e.name) .. " " .. vim.fn.fnameescape(newname))
          update_last_accessed(meta, newname)
          refresh_picker(prompt_bufnr)
        end
      end

      local function act_delete()
        local e = get_entry()
        if not e then return end
        
        -- Confirm deletion
        local confirm = vim.fn.input("Delete session '" .. e.display_name .. "'? [y/N]: ")
        if confirm:lower() ~= "y" then
          return
        end
        
        -- Delete the session file
        local session_path = e.path
        if vim.fn.filereadable(session_path) == 1 then
          vim.fn.delete(session_path)
        end
        
        -- Reload and update metadata
        local current_meta = load_meta()
        if current_meta[e.name] then
          current_meta[e.name] = nil
          save_meta(current_meta)
        end
        
        -- Try plugin command as fallback (in case it does additional cleanup)
        pcall(vim.cmd, "silent! PossessionDelete " .. vim.fn.fnameescape(e.name))
        
        -- Refresh the picker to show updated list
        refresh_picker(prompt_bufnr)
      end

      local function act_favorite()
        local e = get_entry()
        if not e then return end
        local fav = toggle_favorite(meta, e.name)
        e.favorite = fav
        refresh_picker(prompt_bufnr)
      end

      map("i", "<CR>", act_load)
      map("n", "<CR>", act_load)
      map("i", "s", act_save)
      map("n", "s", act_save)
      map("i", "r", act_rename)
      map("n", "r", act_rename)
      map("i", "d", act_delete)
      map("n", "d", act_delete)
      map("i", "f", act_favorite)
      map("n", "f", act_favorite)
      map("i", "R", function() refresh_picker(prompt_bufnr) end)
      map("n", "R", function() refresh_picker(prompt_bufnr) end)
      return true
    end,
  }):find()
end

function M.prompt_save()
  local name = vim.fn.input("Save session as: ", "", "file")
  if name and name ~= "" then
    pcall(vim.cmd, "silent! PossessionSave " .. vim.fn.fnameescape(name))
    local meta = load_meta()
    update_last_accessed(meta, name)
  end
end

return M


