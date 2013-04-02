Meteor.startup ->
  Meteor.methods(
    'get_book': (isbn) ->
      this.unblock()
      result = Meteor.http.get('https://isbndb.com/api/books.xml', {params: {
          "access_key": Meteor.settings["isbndb_api_key"]
          "index1": "isbn"
          "value1": isbn
        }})
      xml2json.parser(result.content)
    'delete_all_books': () ->
      Books.remove({})
  )