###
  MainApp Router
###
AppRouter = Backbone.Router.extend
  routes:
    'books/:isbn': 'book'
    '*path': 'main'

  main: (url_path) ->
    Session.set 'page_id', url_path
    Session.set 'book_isbn', ''

  book: (isbn) ->
    Session.set 'page_id', 'book_single'
    Session.set 'book_isbn', isbn

Router = new AppRouter


###
  History Support
###
Backbone.history.start
  pushState: true

Session.set 'page_url', window.location.pathname

###
  Navigation - Listen for changes to Session.page_url and echo to Router
###
Meteor.autorun (handle) ->
  page_url        = Session.get 'page_url'
  # document.title  = page_url

  Router.navigate page_url, true

###
  Pathchange Support
###
$ () ->
  $.pathchange.init() # setup event listeners, etc.

  $(window).pathchange(() ->
    if Session.get('page_url') isnt window.location.pathname
      Session.set 'page_url', window.location.pathname
  ).trigger "pathchange"