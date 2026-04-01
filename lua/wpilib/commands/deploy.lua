Command = {}

function Command.deploy(args)
	local notifier = require('wpilib.notifier').create_notifier("Deploy Robot Code")
	require('wpilib.commands.commands').run_gradlew("deploy" .. args,
		function(_, data)
			if data ~= "" then
				notifier.update("Building Robot Code...", 50)
			end
		end,

		function(_)
			notifier.finish("Robot Code Deployed!")
		end
	)
end

return Command
