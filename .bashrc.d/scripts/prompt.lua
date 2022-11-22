#!/usr/bin/env lua
---@diagnostic disable: redefined-local
---@diagnostic disable-next-line: unused-local
local inspect = require('inspect')
local signal = require('posix.signal')

local ESC = string.char(27)
local PYTHON = utf8.char(0xe606)
local GIT = utf8.char(0xe725)
local CROSS = utf8.char(0xf655)

local function call(cmd)
    local proc = io.popen(cmd, 'r')
    local out = proc:read('*a')
    local code = proc:close()
    return code == true, out:gsub("%s+$", "")
end

local function split(s, delimiter)
    local result = {}
    for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match);
    end
    return result
end

local function esc(...)
    s = table.concat({...}, ';')
    return ('\\[%s[%sm\\]'):format(ESC, s)
end

local function virtualenv()
    local venv = os.getenv("VIRTUAL_ENV")
    if venv == nil then
        return
    end
    local dir = venv:match("/([^/]+)/([^/]+)$")
    -- 226 234
    return { { fg = 226, bg = 234, text = ('%s %s'):format(PYTHON, dir) } }
end

local function git()
    local result = {}

    local code, branch = call('git rev-parse --symbolic-full-name --abbrev-ref @{u} 2>&1')
    if code ~= true then
        return { { fg = 172, bg = 234, text = ('%s no repo'):format(GIT) } }
    end

    local code, describe = call('git describe --tags --always 2> /dev/null')
    if code == true then
        table.insert(result, { fg = 41, bg = 234, text = (' %s'):format(describe) })
    end

    local code, _ = call('git diff-index --quiet HEAD')
    local color = 41
    if code ~= true then
        color = 226
    end

    if branch ~= 'HEAD' then
        table.insert(result, { fg = color, bg = 234, bold = true, text = ('%s %s'):format(GIT, branch) })
    else
        table.insert(result, { fg = color, bg = 234, bold = true, text = '(detached)' })
    end

    -- local code, info_str = call('git log --abbrev=8 --format="%h%n%an%n%s" -n 1')
    -- local code, hash = call('git log --abbrev=8 --format="%h" -n 1')
    -- table.insert(result, { fg = 203, bg = 234, text = ' ' .. hash })

    return result
end

local function retcode()
    local ret = os.getenv('RET')
    if ret == nil then
        return
    end
    if ret == "130" then
        ret = "0"
    end
    if ret ~= "0" then
        return { { fg = 255, bg = 88, bold = true, text = CROSS .. ' ' .. ret } }
    end
end

local function pwd()
    local pwd = os.getenv('PWD')
    local ws_name = os.getenv('WORKSPACE_NAME')
    local ws_root = os.getenv('WORKSPACE_ROOT')
    local result = {}
    if ws_root ~= nil and pwd:find(ws_root, 1, true) == 1 then
        table.insert(result, { fg = 203, bg = 234, bold = true, text = ('[%s]'):format(ws_name) })
        pwd = pwd:sub(#ws_root + 1)
    else
        pwd = pwd:gsub(os.getenv('HOME'), '~')
    end
    pwd = pwd:gsub('^/', ''):gsub('/$', '')
    if #pwd > 0 then
        for _, part in pairs(split(pwd, '/')) do
            table.insert(result, { fg = 203, bg = 234, text = (' %s ').format(part) })
        end
    end

    -- Result empty, must be root
    if #result == 0 then
        table.insert(result, { fg = 203, bg = 234, text = '/' })
    end

    -- Insert slashes
    for i = 2, #result * 2 - 1, 2 do
        table.insert(result, i, { fg = 238, bg = 234, text = '/' })
    end

    -- table.insert(result, 1, { bg = 234, text = ' ' })
    -- table.insert(result, { bg = 234, text = ' ' })
    return result
    -- return { { fg = 203, bg = 234, text = result } }
end

local function br()
    return { { text = '\n' } }
end

local rows = { { virtualenv, git, retcode }, { pwd } }

signal.signal(signal.SIGINT, function ()
    os.exit(130)
end)

for row_index, row in pairs(rows) do
    local printed = false
    for segment_index, segment in pairs(row) do
        local parts = segment()
        if parts ~= nil then
            if printed then
                io.write(esc(48, 5, 234) .. ' ' .. esc(0))
            end
            printed = true
            for index, value in pairs(parts) do
                local flag = 0
                if value.bold then
                    flag = 1
                end
                if value.invert then
                    flag = 3
                end
                if value.underline then
                    flag = 4
                end
                if value.fg ~= nil then
                    io.write(esc(flag, 38, 5, value.fg))
                end
                if value.bg ~= nil then
                    io.write(esc(48, 5, value.bg))
                end
                if index > 1 then
                    io.write(' ')
                end
                io.write(value.text)
                io.write(esc(0))
            end
        end
    end
    if printed and row_index ~= #rows then
        io.write('\n')
    end
end
io.write(esc(1, 38, 2) .. ' $ ' .. esc(0))
