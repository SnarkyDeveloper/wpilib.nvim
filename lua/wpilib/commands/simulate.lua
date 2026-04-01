Command = {}

function Command.sim(args)
	local notifier = require('wpilib.notifier').create_notifier("Starting Robot Code Simulation")
	require('wpilib.commands.commands').run_gradlew("build" .. args,
		function(_, data)
			if data ~= "" then
				notifier.update("Building Robot Code...", 50)
			end
		end,

		function(_)
			notifier.finish("Simulation Started!")
		end
	)
end

return Command
