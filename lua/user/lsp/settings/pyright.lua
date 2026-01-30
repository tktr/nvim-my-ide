return {
  settings = {
    pyright = {
      disableOrganizeImports = true,
      disableTaggedHints = true,
    },
    python = {
      venvPath = ".",
      -- uv-managed virtualenv lives at <project>/.venv by convention.
      -- Pin the venv name so pyright doesn't spend time searching.
      venv = ".venv",
      analysis = {
        -- Keep editor CPU/memory usage reasonable.
        diagnosticMode = "openFilesOnly",
        -- Never treat virtualenvs as project source.
        exclude = {
          "**/.venv/**",
          "**/venv/**",
          "**/.tox/**",
          "**/.nox/**",
        },
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
