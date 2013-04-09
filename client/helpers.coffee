## book_entry_summary ##
Template.book_entry_summary.helpers({
  extractExcerpt: (options) ->
    maxLength = 150
    descs = this.description.split('\n\n')
    console.log descs, descs[0].length
    if descs[0].length <= maxLength
      descs[0]
    else
      descs[0].slice(0,maxLength) + "..."
})

Handlebars.registerHelper('join', (items) ->
  block = _.last arguments
  delimiter = block.hash.delimiter or ","
  start = start = block.hash.start or 0
  len = (if items then items.length else 0)
  end = block.hash.end or len
  out = ""

  if end > len then end = len
  
  if 'function' == typeof block
    for i in [start..end]
      if i > start then out += delimiter;
      if 'string' == typeof items[i]
        out += items[i]
      else
        out += block(items[i])
    out
  else
    [].concat(items).slice(start, end).join(delimiter)
)