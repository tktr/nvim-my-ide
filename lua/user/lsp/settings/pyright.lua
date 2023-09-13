return {
  settings = {
    python = {
      venvPath = ".",
      analysis = {
        diagnosticMode = "workspace",
        -- https://github.com/microsoft/pyright/blob/main/docs/configuration.md#diagnostic-rule-defaults
        diagnosticSeverityOverrides = {
          reportGeneralTypeIssues= "warning",
          reportMissingParameterType= "warning",
          reportUnknownArgumentType= "warning",
          reportUnknownLambdaType= "warning",
          reportUnknownMemberType= "warning",
          reportUnknownParameterType= "warning",
          reportUnknownVariableType= "warning",
        },
        typeCheckingMode = "strict",
      },
    },
  },
}
