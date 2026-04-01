Command = {}

function Command.build(args)
	local notifier = require('wpilib.notifier').create_notifier("Starting Robot Build Code")
	require('wpilib.commands.commands').run_gradlew("build" .. args,
		function(_, data)
			if data ~= "" then
				notifier.update("Building Robot Code...", 50)
			end
		end,

		function(_)
			notifier.finish("Robot Code Built!")
		end
	)
end

return Command
