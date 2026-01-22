return {
  settings = {
    pyright = {
      disableOrganizeImports = true,
      disableTaggedHints = true,
    },
    python = {
      venvPath = ".",
      analysis = {
        diagnosticMode = "workspace",
        -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#diagnostic-rule-defaults
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
}
