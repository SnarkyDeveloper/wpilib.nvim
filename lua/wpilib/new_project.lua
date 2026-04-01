--[[
	wpilib.nvim
		Unofficial Neovim plugin for FRC
	
	(c) 2023 frc4533-lincoln & 2026 SnarkyDev
]]

local M = {}

local util = require('wpilib.util')

local versions_url = 'https://github.com/SnarkyDeveloper/wpilib.nvim/raw/main/versions.lua'
local storage_path = util.storage_path

local Menu = require('nui.menu')

function M.new_project(version)
	local menu_opts = util.menu_opts
	menu_opts.border.text.top = 'New Project'

	local menu = Menu(menu_opts, {
		lines = {
			Menu.item('Java'),
			Menu.item('C++'),
		},
		on_submit = function (item)
			local tbl = {
				['Java'] = function ()
					return M.dl_templates('java', 'v'..version)
				end,
				['C++'] = function ()
					return M.dl_templates('cpp', 'v'..version)
				end,
			}
			local tmpls_path = tbl[item.text]()

			local tmpls = vim.json.decode(io.open(tmpls_path..'/templates.json', 'r'):read('a'))
			if tmpls then
				for _, tmpl in ipairs(tmpls) do
					print(tmpl.name)
				end
			else
				print('invalid templates.json')
			end
		end,
	})

	vim.schedule(function ()
		menu:mount()
	end)
end

local function fetch(repo, tag, path, dest)
	if not vim.fn.executable('curl') then
		print('curl not installed')
		return
	end

	local api = string.format(
		'https://api.github.com/repos/%s/contents/%s?ref=%s',
		repo, path, tag
	)

	vim.fn.mkdir(storage_path .. '/' .. dest, 'p')

	local handle = io.popen('curl -s "' .. api .. '"')
	local result = handle and handle:read("*a") or nil
	if result == nil then
		return
	end
	local ok_close = handle and handle:close()
	if not ok_close then
		print("failed to fetch directory: " .. path)
		return
	end


	local ok, data = pcall(vim.json.decode, result)
	if not ok or type(data) ~= "table" then
		print("failed to fetch directory: " .. path)
		return
	end

	for _, item in ipairs(data) do
		local target = storage_path .. '/' .. dest .. '/' .. item.name

		if item.type == "file" then
			os.execute(string.format(
				'curl -L -s "%s" -o "%s"',
				item.download_url,
				target
			))

		elseif item.type == "dir" then
			fetch(repo, tag, path .. '/' .. item.name, dest .. '/' .. item.name)
		end
	end
end
function M.fetch_versions()
	if vim.fn.executable('wget') then
		vim.fn.mkdir(storage_path, 'p')
    os.execute('wget -q -O "'..storage_path..'/versions.lua" "'..versions_url..'"')
	else
		print('wget not installed')
	end
end

function M.dl_templates(lang, version)
	local dest = version..'/templates/'..lang
	local tbl = {
		['java'] = function ()
			fetch(
				'wpilibsuite/allwpilib',
				version,
				'wpilibjExamples/src/main/java/edu/wpi/first/wpilibj/templates',
				dest
			)
		end,
		['cpp'] = function ()
			fetch(
				'wpilibsuite/allwpilib',
				version,
				'wpilibcExamples/src/main/cpp/templates',
				dest
			)
		end,
	}

	tbl[lang]()
	return storage_path..'/'..dest
end

return M
