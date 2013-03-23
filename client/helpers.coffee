## book_entry_summary ##
Template.book_entry_summary.helpers({
  extractExcerpt: (options) ->
    compiledHtml = options.fn this
    $(compiledHtml).first()[0].outerHTML
})