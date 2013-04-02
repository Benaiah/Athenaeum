Meteor.startup ->
  theme = amplify.store('athenaeum-theme')
  if theme then Session.set('theme', theme) else Session.set('theme', 'light')

Meteor.autorun (handle) ->
  theme = Session.get 'theme'
  $('body').removeClass().addClass('theme-'+theme)
  amplify.store('athenaeum-theme', theme)

###
  book_list
###
Template.book_list.books = ->
    Books.find({}, {sort:{title:1, author:1}})

###
  book_entry_full
###
Template.book_entry_full.book = ->
  isbn = Session.get 'book_isbn'.replace(/-/g, '')
  book = Books.findOne { 'isbn': isbn }

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

###
  not_found
###
Template.not_found.title = ->
  notFoundTitleOriginal = Session.get 'not_found_title'
  notFoundTitle = notFoundTitleOriginal.toUpperCase() + notFoundTitleOriginal.slice(1)
  notFoundTitle

###
  settings
###

# properties
Template.settings.darkTheme = ->
  if Session.get('theme') is 'dark' then true else false

#events
Template.settings.events =
  'click .toggle-theme': ->
    if Session.get('theme') is 'light' then Session.set('theme', 'dark') else Session.set('theme', 'light')