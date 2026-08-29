Command = {}

function Command.deploy(args)
	if not require('wpilib.commands.commands').is_valid_project() then
		vim.notify("Not a WPILib project", vim.log.levels.ERROR)
		return
	end

	local notifier = require('wpilib.notifier').create_notifier("Deploy Robot Code")
	require('wpilib.commands.commands').run_gradlew("deploy", args,
		function(_, data)
			if not data or data == "" then return end

			notifier.update("Building Robot Code...", 50)

			if data:find("BUILD SUCCESSFUL") then
				notifier.update("Robot Code Built!", 75)
			elseif data:find("BUILD FAILED") then
				notifier.finish("Deploy Failed! Check logs.")
			end
		end,
		function(_)
			notifier.finish("Robot Code Deployed!")
		end
	)
end

return Command
