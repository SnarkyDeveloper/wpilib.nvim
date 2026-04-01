local M = {}

function M.create_notifier(opts)
    opts = opts or {}

    local has_fidget, fidget = pcall(require, "fidget.progress")

    local messages = {
        start = opts.start or "Starting...",
        update = opts.update or "In progress...",
        done = opts.done or "Done!",
    }

    if has_fidget then
        local handle = fidget.handle.create({
            title = opts.title or "Task",
            message = messages.start,
            percentage = 0,
        })

        return {
            update = function(msg, percent)
                handle.message = msg or messages.update
                if percent then
                    handle.percentage = percent
                end
            end,

            finish = function(msg)
                handle.message = msg or messages.done
                handle:finish()
            end
        }
    else
        vim.notify(messages.start, vim.log.levels.INFO)

        return {
            update = function() end,
            finish = function(msg)
                vim.notify(msg or messages.done, vim.log.levels.INFO)
            end
        }
    end
end


return M
