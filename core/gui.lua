-- Copyright 2007-2010 Mitchell Foral mitchell<att>caladbolg.net. See LICENSE.

local gui = _G.gui

-- LuaDoc is in core/.gui.lua.
function gui.check_focused_buffer(buffer)
  if type(buffer) ~= 'table' or not buffer.doc_pointer then
    error(locale.ERR_BUFFER_EXPECTED, 2)
  elseif gui.focused_doc_pointer ~= buffer.doc_pointer then
    error(locale.ERR_BUFFER_NOT_FOCUSED, 2)
  end
end

-- LuaDoc is in core/.gui.lua.
function gui._print(buffer_type, ...)
  local function safe_print(...)
    local message = table.concat({...}, '\t')
    local message_buffer, message_buffer_index
    local message_view, message_view_index
    for index, buffer in ipairs(_BUFFERS) do
      if buffer._type == buffer_type then
        message_buffer, message_buffer_index = buffer, index
        for jndex, view in ipairs(_VIEWS) do
          if view.doc_pointer == message_buffer.doc_pointer then
            message_view, message_view_index = view, jndex
            break
          end
        end
        break
      end
    end
    if not message_view then
      local _, message_view = view:split(false) -- horizontal split
      if not message_buffer then
        message_buffer = new_buffer()
        message_buffer._type = buffer_type
        events.emit('file_opened')
      else
        message_view:goto_buffer(message_buffer_index, true)
      end
    else
      gui.goto_view(message_view_index, true)
    end
    message_buffer:append_text(message..'\n')
    message_buffer:set_save_point()
  end
  pcall(safe_print, ...) -- prevent endless loops if this errors
end

-- LuaDoc is in core/.gui.lua.
function gui.print(...) gui._print(locale.MESSAGE_BUFFER, ...) end

-- LuaDoc is in core/.gui.lua.
function gui.switch_buffer()
  local items = {}
  for _, buffer in ipairs(_BUFFERS) do
    local filename = buffer.filename or buffer._type or locale.UNTITLED
    local dirty = buffer.dirty and '*' or ''
    items[#items + 1] = dirty..filename:match('[^/\\]+$')
    items[#items + 1] = filename
  end
  local out =
    gui.dialog('filteredlist',
                     '--title', locale.SWITCH_BUFFERS,
                     '--button1', 'gtk-ok',
                     '--button2', 'gtk-cancel',
                     '--no-newline',
                     '--columns', 'Name', 'File',
                     '--items', unpack(items))
  local i = tonumber(out:match('%-?%d+$'))
  if i and i >= 0 then view:goto_buffer(i + 1, true) end
end