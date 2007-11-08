-- Copyright 2007 Mitchell Foral mitchell<att>caladbolg.net. See LICENSE.
-- This is a DUMMY FILE used for making LuaDoc for built-in functions in the
-- global textadept.find table.

---
-- Textadept's integrated find/replace dialog.
-- [Dummy file]
module('textadept.find')

---
-- Textadept's find table.
-- @class table
-- @name textadept.find
-- @field find_entry_text The text in the find entry.
-- @field replace_entry_text The text in the replace entry.
find = { find_entry_text = nil, replace_entry_text = nil }

--- Displays and focuses the find/replace dialog.
function focus() end