Command = {}

function Command.build(args)
	if not require('wpilib.commands.commands').is_valid_project() then
		vim.notify("Not a WPILib project", vim.log.levels.ERROR)
		return
	end
	local notifier = require('wpilib.notifier').create_notifier("Starting Robot Build Code")
	require('wpilib.commands.commands').run_gradlew("build", args,
		function(_, data)
			if not data or data == "" then return end

			notifier.update("Building Robot Code...", 50)

			if data:find("BUILD FAILED") then
				notifier.finish("Deploy Failed! Check logs.")
			end
		end,
		function(_)
			notifier.finish("Robot Code Built!")
		end
	)
end

return Command
