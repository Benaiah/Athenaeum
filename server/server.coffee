Books = @Books

Meteor.methods(
  'getIsbnInfoFromExternalService': (isbn) ->
    this.unblock()
    result = Meteor.http.get('https://isbndb.com/api/books.xml', {params: {
        "access_key": Meteor.settings["isbndb_api_key"]
        "index1": "isbn"
        "value1": isbn
        "results": "texts"
      }})
    json = XML2JS.parse(result.content)
    unless json.ISBNdb.BookList[0].$.total_results > 0
      throw new Meteor.Error 404, "No book was found"
    bookData = json.ISBNdb.BookList[0].BookData[0]
    sanData = (str, def) ->
      def = (if def then def else "")
      if typeof str is "string" then str else def
    book =
      isbn        : sanData(bookData.$.isbn)
      isbn13      : sanData(bookData.$.isbn13)
      title       : sanData(bookData.Title[0])
      fullTitle   : sanData(bookData.TitleLong[0])
      publisher   : sanData(bookData.PublisherText[0]._)
      publisherId : sanData(bookData.PublisherText[0].$.publisher_id)
      description : sanData(bookData.Summary[0])
      authors     : _.reject(
        _.map(
          bookData.AuthorsText[0].split(','),
          (s) -> return s.trim()),
        (s) -> return s == "")
    book
  'deleteAllBooks': () ->
    Books.remove({})
)