return {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        local actions = require("telescope.actions")
        local action_state = require("telescope.actions.state")
        local pickers = require("telescope.pickers")
        local finders = require("telescope.finders")
        local conf = require("telescope.config").values

        -- Template definitions
        local templates = {
            class = function(name)
                return string.format([[
namespace %s
{
    public class %s
    {
        public %s()
        {
        }
    }
}]], vim.fn.fnamemodify(vim.fn.getcwd(), ':t'), name, name)
            end,
            interface = function(name)
                return string.format([[
namespace %s
{
    public interface %s
    {
    }
}]], vim.fn.fnamemodify(vim.fn.getcwd(), ':t'), name)
            end,
            record = function(name)
                return string.format([[
namespace %s
{
    public record %s(
    );
}]], vim.fn.fnamemodify(vim.fn.getcwd(), ':t'), name)
            end,
            ["record class"] = function(name)
                return string.format([[
namespace %s
{
    public record class %s
    {
        public %s()
    {
    }
}]], vim.fn.fnamemodify(vim.fn.getcwd(), ':t'), name, name)
            end
        }

        -- Function to get the current directory
        local function get_current_directory()
            -- Get the current buffer's directory
            local current_path = vim.fn.expand('%:p:h')
            
            -- If it's empty, fall back to the current working directory
            if current_path == '' then
                current_path = vim.fn.getcwd()
            end
            
            return current_path
        end

        -- Function to create new C# file
        local function create_cs_file(template_type, name)
            local dir_path = get_current_directory()
            local file_path = dir_path .. '/' .. name .. '.cs'
            
            -- Create directories if they don't exist
            vim.fn.mkdir(vim.fn.fnamemodify(file_path, ':h'), 'p')
            
            local file = io.open(file_path, 'w')
            if file then
                -- Get the root namespace from the nearest .csproj file or fallback to directory name
                local namespace = vim.fn.fnamemodify(dir_path, ':t')
                local current_dir = dir_path
                while current_dir ~= '/' do
                    local csproj_files = vim.fn.glob(current_dir .. '/*.csproj')
                    if csproj_files ~= '' then
                        namespace = vim.fn.fnamemodify(current_dir, ':t')
                        break
                    end
                    current_dir = vim.fn.fnamemodify(current_dir, ':h')
                end
                
                -- Add subdirectories to namespace
                local relative_path = vim.fn.fnamemodify(dir_path, ':~:.:gs?/?\\?')
                if relative_path ~= '.' then
                    local sub_namespace = vim.fn.substitute(relative_path, '^[^\\]*\\\\?', '', '')
                    if sub_namespace ~= '' then
                        namespace = namespace .. '.' .. vim.fn.substitute(sub_namespace, '\\', '.', 'g')
                    end
                end
                
                file:write(templates[template_type](name):gsub('namespace [^\n]+', 'namespace ' .. namespace))
                file:close()
                
                -- Open the newly created file
                vim.cmd('edit ' .. file_path)
            end
        end

        -- Create file picker
        local function new_cs_file()
            local template_types = { "class", "interface", "record", "record class" }
            
            pickers.new({}, {
                prompt_title = "New C# File Type",
                finder = finders.new_table {
                    results = template_types
                },
                sorter = conf.generic_sorter({}),
                attach_mappings = function(prompt_bufnr, map)
                    actions.select_default:replace(function()
                        local selection = action_state.get_selected_entry()
                        actions.close(prompt_bufnr)
                        
                        -- Prompt for file name
                        vim.ui.input({
                            prompt = "Enter file name (without .cs): ",
                        }, function(name)
                            if name and name ~= "" then
                                create_cs_file(selection[1], name)
                            end
                        end)
                    end)
                    return true
                end,
            }):find()
        end

        -- Register command
        vim.api.nvim_create_user_command('NewCSharpFile', new_cs_file, {})

        -- Add keymapping
        vim.keymap.set('n', '<leader>nc', ':NewCSharpFile<CR>', { noremap = true, silent = true, desc = "New C# File" })
    end
}