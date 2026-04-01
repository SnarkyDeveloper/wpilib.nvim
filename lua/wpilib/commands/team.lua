local Command = {}

function Command.setTeam(args)
	args = args or {}
	if not require('wpilib.commands.commands').is_valid_project() then
		vim.notify("Not a WPILib project", vim.log.levels.ERROR)
		return
	end

	local path = vim.uv.cwd() .. "/.wpilib/"
	local file = path .. "wpilib_preferences.json"

	local lines = vim.fn.readfile(file)
	local content = table.concat(lines, "\n")
	local ok, data = pcall(vim.json.decode, content)

	if not ok or type(data) ~= "table" then
		vim.notify("Invalid wpilib_preferences.json", vim.log.levels.ERROR)
		return
	end

	if not args[1] then
		vim.notify("Team Number: " .. tostring(data.teamNumber or "not set"))
		return
	end

	local num = tonumber(args[1])
	if not num then
		vim.notify("Invalid team number", vim.log.levels.ERROR)
		return
	end

	data.teamNumber = num
	vim.fn.writefile({ vim.json.encode(data) }, file)

	vim.notify("Set team number to " .. num)
end

return Command
