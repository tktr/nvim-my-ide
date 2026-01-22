return {
  settings = {
    yaml = {
      keyOrdering = false,
      schemas = {
        kubernetes = { "**/ansible-role-k8s-coss/files/**/*.yaml", "**/k8s/*.yaml" },
      },
    },
  },
}
