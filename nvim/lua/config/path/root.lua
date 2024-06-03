local patterns = { ".git" }

util.root.detectors = {
  util.root.helper.lsp,
  function(bufnr)
    return util.root.helper.pattern(bufnr, patterns)
  end,
  util.root.helper.cwd,
}
