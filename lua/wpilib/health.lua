local M = {}

local function frc_robot_connected()
	require('wpilib.commands.commands').run_gradlew("discoverRoborio", function () end, function (obj)
		if obj.code == 0 then
			return true
		end
	end, true)
	return false
end

function M.check()
	local health = vim.health or require("health")

	health.start("FRC")

	if frc_robot_connected() then
		health.ok("Robot: Connected")
	else
		health.error("Robot: Not connected")
	end

	if vim.fn.executable("curl") == 1 then
		health.ok("curl is installed")
	else
		health.warn("curl not found (needed for downloads)")
	end
end

return M
