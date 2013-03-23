###
  book_list
###
Template.book_list.books = ->
    Books.find()

###
  book_entry_full
###
Template.book_entry_full.book = ->
  book = Books.findOne Session.get 'book_id'
  if book
    notMetadata = ['title', '_id', 'metadata', 'description']
    book.metadata = []
    _.each book, (val, key, list) ->
      unless key in notMetadata
        book.metadata.push({
          key: key
          value: val
        })
    book