Books = @Books
validate = @validate

Meteor.startup ->
  theme = amplify.store('athenaeum-theme')
  if theme then Session.set('theme', theme) else Session.set('theme', 'light')

Meteor.autorun (handle) ->
  theme = Session.get 'theme'
  $('body').removeClass().addClass('theme-'+theme)
  amplify.store('athenaeum-theme', theme)

###
  add_book_modal
###
Template.add_book_modal.rendered = ->
  $('#add-book-modal').on('hidden', () ->
    resetAddBookModal()
    resetAddBookDataForm()
  )

###
  add_book_modal_body
###

# properties
Template.add_book_modal_body.validationError         = -> Session.get 'add_book_modal_body.validationError'
Template.add_book_modal_body.isbnHasBeenInput        = -> Session.get 'add_book_modal_body.isbnHasBeenInput'
Template.add_book_modal_body.bookDataHasBeenReceived = -> Session.get 'add_book_modal_body.bookDataHasBeenReceived'
Template.add_book_modal_body.bookDataTransferError   = -> Session.get 'add_book_modal_body.bookDataTransferError'
resetAddBookModal = () ->
  Session.set 'add_book_modal_body.validationError', false
  Session.set 'add_book_modal_body.isbnHasBeenInput', false
  Session.set 'add_book_modal_body.bookDataHasBeenReceived', false
  Session.set 'add_book_modal_body.bookDataTransferError', false
  Session.get 'add_book_modal_body.isbnHasBeenInput'

# events
Template.add_book_modal_body.events =
  'click #submit-isbn-number': ->
    isbnNumber = $("#input-isbn-number").val()
    if validate.isbn(isbnNumber)
      Session.set 'add_book_modal_body.validationError', false
      Session.set 'add_book_modal_body.isbnHasBeenInput', true
      Meteor.call "getIsbnInfoFromExternalService", isbnNumber, (error, result) ->
        Session.set 'add_book_modal_body.bookDataHasBeenReceived', true
        unless error
          Session.set 'add_book_data_form.bookData', result
        else
          Session.set 'add_book_modal_body.bookDataTransferError', error
    else
      Session.set 'add_book_modal_body.validationError', true

###
  add_book_data_form
###

# properties
Template.add_book_data_form.isbnHasBeenInput   = -> Session.get 'add_book_modal_body.isbnHasBeenInput'
Template.add_book_data_form.bookData           = -> Session.get 'add_book_data_form.bookData'
Template.add_book_data_form.bookDataSubmitted  = -> Session.get 'add_book_data_form.bookDataSubmitted'
Template.add_book_data_form.bookInserted       = -> Session.get 'add_book_data_form.bookInserted'
Template.add_book_data_form.bookInsertionError = -> Session.get 'add_book_data_form.bookInsertionError'
resetAddBookDataForm = () ->
  Session.set 'add_book_modal_body.isbnHasBeenInput', false
  Session.set 'add_book_data_form.bookData', false
  Session.set 'add_book_data_form.bookDataSubmitted', false
  Session.set 'add_book_data_form.bookInserted', false
  Session.set 'add_book_data_form.bookInsertionError', false
Template.add_book_data_form.rendered = () ->
  $("#input-bookData-description").expandingTextarea()

# events
Template.add_book_data_form.events =
  'click #submit-bookData': ->
    Session.set 'add_book_data_form.bookDataSubmitted', true
    getBookParam = (str) ->
      $('#input-bookData-' + str).val()
    book =
      isbn        : getBookParam('isbn')
      isbn13      : getBookParam('isbn13')
      title       : getBookParam('title')
      fullTitle   : getBookParam('fullTitle')
      description : getBookParam('description')
      publisher   : getBookParam('publisher')
      publisherId : getBookParam('publisherId')
      authors     : _.reject(
        _.map(
          getBookParam('authors').split(','),
          (s) -> return $.trim(s)),
        (s) -> return s == "")
    Books.insert(book, (error, id) ->
      Session.set 'add_book_data_form.bookInserted', true
      if error
        Session.set 'add_book_data_form.bookInsertionError', error
    )


###
  book_list
###
Template.book_list.listView = -> Session.get 'book_list.listView'
Template.book_list.books = ->
    Books.find({}, {sort:{title:1, author:1}})

###
  book_entry_full
###
Template.book_entry_full.bookNotFound = -> Session.get 'book_entry_full.bookNotFound'
Template.book_entry_full.book = ->
  isbn = Session.get 'book_isbn'.replace(/-/g, '')
  book = Books.findOne { 'isbn': isbn }

  if book
    Session.set 'book_entry_full.bookNotFound', false
    notMetadata = ['title', '_id', 'metadata', 'description']
    book.metadata = []
    _.each book, (val, key, list) ->
      unless key in notMetadata
        book.metadata.push({
          key: key
          value: val
        })
    book
  # else
  #   Session.set 'not_found.title', 'book'
  #   Session.set 'book_entry_full.bookNotFound', true

###
  not_found
###
Template.not_found.title = ->
  notFoundTitleOriginal = Session.get 'not_found.title'
  notFoundTitle = notFoundTitleOriginal.slice(0,1).toUpperCase() + notFoundTitleOriginal.slice(1)
  notFoundTitle

###
  settings
###

# properties
Template.settings.darkTheme = ->
  if Session.get('theme') is 'dark' then true else false

# events
Template.settings.events =
  'click .toggle-theme': ->
    if Session.get('theme') is 'light' then Session.set('theme', 'dark') else Session.set('theme', 'light')