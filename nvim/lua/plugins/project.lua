return {
  "ahmedkhalf/project.nvim",
  event = "VeryLazy",
  config = function()
    require("project_nvim").setup({
      detection_methods = { "lsp", "pattern" },
      patterns = { ".git", "Makefile", "package.json", "go.mod" }, -- add go.mod for Go projects
    })
    require("telescope").load_extension("projects")
  end,
}
