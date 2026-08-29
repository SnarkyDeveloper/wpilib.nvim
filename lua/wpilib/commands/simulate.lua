Command = {}

local function is_java_wpilib()
  local cwd = vim.uv.cwd()
  local java_path = cwd .. "/src/main/java"
  local stat = vim.uv.fs_stat(java_path)
  return (stat and stat.type == "directory") or false
end

function Command.sim(args)
	if not require('wpilib.commands.commands').is_valid_project() then
		vim.notify("Not a WPILib project", vim.log.levels.ERROR)
		return
	end
	local simulate_cmd = 'simulate' .. (is_java_wpilib() and "Java" or "Native")
	local notifier = require('wpilib.notifier').create_notifier("Starting Robot Code Simulation")
	require('wpilib.commands.commands').run_gradlew(simulate_cmd, args,
		function(_, data)
			if not data or data == "" then return end
			notifier.update("Building Robot Code...", 50)
			if data:find("BUILD SUCCESSFUL") then
				notifier.update("Built Robot Code!", 75)
			elseif data:find("BUILD FAILED") then
				notifier.finish("Deploy Failed! Check logs.")
			end
		end,

		function(_)
			notifier.finish("Simulation Started!")
		end
	)
end

return Command
