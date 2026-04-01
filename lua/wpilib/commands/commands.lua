local function create_command(name)
	local subcommands = {}

	local function run(opts)
		local args = opts.fargs
		local sub = args[1]

		if not sub or not subcommands[sub] then
			vim.notify("Unknown subcommand: " .. (sub or ""), vim.log.levels.ERROR)
			return
		end

		local new_args = { unpack(args, 2) }
		subcommands[sub].fn(new_args, opts)
	end

	vim.api.nvim_create_user_command(name, run, {
		nargs = "*",
		complete = function(_, line)
			local parts = vim.split(line, "%s+")
			if #parts <= 2 then
				return vim.tbl_keys(subcommands)
			end
			return {}
		end,
	})

	return {
		add_subcommand = function(cmd, fn, opts)
			subcommands[cmd] = {
				fn = fn,
				opts = opts or {}
			}
		end
	}
end

local T = {}

function T.init_commands()
	local commands = create_command("FRC")
	commands.add_subcommand(
		"teamNumber",
		require('wpilib.commands.team').setTeam
	)
	commands.add_subcommand(
		"build",
		require('wpilib.commands.build').build
	)
end

function T.is_valid_project()
	local path = vim.uv.cwd() .. "/.wpilib/"
	local file = path .. "wpilib_preferences.json"

	if vim.fn.isdirectory(path) == 0 then
		vim.notify("Not a WPILib project", vim.log.levels.ERROR)
		return false
	end

	if vim.uv.fs_stat(path .. file) then
		return true
	end
end


function T.run_gradlew(cmd, cb, exit_cb, sync)
	sync = sync or false
	if T.is_valid_project() then
        if type(cb) ~= "function" or type(exit_cb) ~= "function" then
            return
        end

        local res = vim.system({ './gradlew', cmd }, {
            stdout = function(err, data)
                if data then
                    vim.schedule(function()
                        cb(err, data)
                    end)
                end
            end,
            text = true,
        }, function(obj)
            vim.schedule(function()
                exit_cb(obj)
            end)
        end)

		if sync then
			res:wait()
		end
    end
end


return T
