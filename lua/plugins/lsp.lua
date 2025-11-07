return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "mfussenegger/nvim-lint",
    "mhartington/formatter.nvim",
  },
  config = function()
    local servers = {
      "lua_ls",
      "ruff",
      "pyright",
      "cssls",
      "html",
      "tsserver",
      "bashls",
      "jsonls",
      "yamlls",
      "ansiblels",
      "marksman",
      "esbonio",
      "rnix",
    }

    local server_settings = {
      lua_ls = {
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
            workspace = {
              library = {
                [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                [vim.fn.stdpath("config") .. "/lua"] = true,
              },
            },
            telemetry = {
              enable = false,
            },
          },
        },
      },
      pyright = {
        settings = {
          pyright = {
            disableOrganizeImports = true,
            disableTaggedHints = true,
          },
          python = {
            venvPath = ".",
            analysis = {
              diagnosticMode = "workspace",
              diagnosticSeverityOverrides = {
                reportUndefinedVariable = "none",
                reportGeneralTypeIssues = "warning",
                reportMissingParameterType = "warning",
                reportUnknownArgumentType = "warning",
                reportUnknownLambdaType = "warning",
                reportUnknownMemberType = "warning",
                reportUnknownParameterType = "warning",
                reportUnknownVariableType = "warning",
              },
              typeCheckingMode = "strict",
            },
          },
        },
      },
      ruff = {
        settings = {
          fixAll = true,
          organizeImports = true,
          logLevel = "info",
        },
      },
      ansiblels = {
        settings = {
          ansible = {
            ansible = {
              path = "ansible",
            },
            executionEnvironment = {
              enabled = false,
            },
            python = {
              interpreterPath = "python",
            },
            validation = {
              enabled = true,
              lint = {
                enabled = true,
                path = "ansible-lint",
              },
            },
          },
        },
      },
      yamlls = {
        settings = {
          yaml = {
            keyOrdering = false,
            schemas = {
              kubernetes = { "**/ansible-role-k8s-coss/files/**/*.yaml", "**/k8s/*.yaml" },
            },
          },
        },
      },
    }

    local settings = {
      ui = {
        border = "none",
        icons = {
          package_installed = "◍",
          package_pending = "◍",
          package_uninstalled = "◍",
        },
      },
      log_level = vim.log.levels.INFO,
      max_concurrent_installers = 4,
    }

    require("mason").setup(settings)
    require("mason-lspconfig").setup({
      ensure_installed = servers,
      automatic_installation = true,
    })

    local opts = {}

    for _, server in pairs(servers) do
      opts = {
        on_attach = require("utils.handlers").on_attach,
        capabilities = require("utils.handlers").capabilities,
      }

      server = vim.split(server, "@")[1]

      if server_settings[server] then
        opts = vim.tbl_deep_extend("force", server_settings[server], opts)
      end

      require("lspconfig")[server].setup(opts)
    end

    require("lint").linters_by_ft = {
      python = { "ruff" },
      ansible = { "ansible-lint" },
    }

    require("formatter").setup({
      logging = true,
      log_level = vim.log.levels.WARN,
      filetype = {
        lua = {
          require("formatter.filetypes.lua").stylua,
        },
        python = {
          require("formatter.filetypes.python").black,
        },
        toml = {
          require("formatter.filetypes.toml").prettier,
        },
        java = {
          require("formatter.filetypes.java").google_java_format,
        },
        ["*"] = {
          require("formatter.filetypes.any").remove_trailing_whitespace,
        },
      },
    })

    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
        vim.cmd("FormatWrite")
      end,
    })
  end,
}
