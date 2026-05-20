return {
  settings = {
    ty = {
      -- Onboard ty gradually: use it for type diagnostics while Pyright remains
      -- the primary Python language-services provider during the transition.
      disableLanguageServices = true,
      diagnosticMode = "openFilesOnly",
    },
  },
}
