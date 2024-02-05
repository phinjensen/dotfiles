-- configuration for https://github.com/mfussenegger/nvim-jdtls
-- A correctly configured '-data' option (see below in config.cmd) is necessary to make imports work correctly
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

-- Find the first directory which has a gradlew, .git, or mvnw file, searching upward
local root_dir = vim.fs.dirname(vim.fs.find({ 'pom.xml', 'gradlew', '.git', 'mvnw' }, { upward = true })[1])

local config = {
    cmd = {
        '/home/phin/.local/share/jdt-language-server/bin/jdtls',
        '-data',
        '/home/phin/eclipse-workspace/' .. project_name
    },
    root_dir = root_dir,
    settings = {
        java = {
            configuration = {
                runtimes = {
                    {
                        name = "JavaSE-17",
                        path = "/usr/lib/jvm/java-17-openjdk/",
                        default = true,
                    },
                }
            },
            format = {
                settings = {
                    url = "/home/phin/.config/lvim/lsp-settings/java-formatter.xml"
                }
            }
        }
    }
}
require('jdtls').start_or_attach(config)
