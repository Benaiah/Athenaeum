Template.page_controller.pages = [
  'index'
  'about'
  'book_single'
]

Template.page_controller.display_page = () ->
  page_index = Session.get 'page_id'

  console.log page_index
  if page_index.length > 1
    if page_index.charAt(0) == "/"
      page_index = page_index.substring 1, page_index.length

    if page_index.charAt(page_index.length-1) == "/"
      page_index = page_index.substring(0, page_index.length-1)

  if page_index == ''
   page_index = 'index'

  if Template[page_index] and page_index in Template.page_controller.pages
    Template[page_index]()
  else
    Session.set 'not_found_title', 'page'
    Template['not_found']()

Template.page_controller.events =
  'click .navlink': (event) ->
    event.preventDefault()

    # get the path from the link
    # reg = /.+?\:\/\/.+?(\/.+?)(?:#|\?|$)/
    pathname = event.currentTarget.pathname

    # set the session variable
    Session.set 'page_url', pathname

## Make mobile browsers navigate instantly ##
Template.page_controller.rendered = () ->
  new FastClick(document.body);

  $('body').on('touchmove', (e) ->
    unless $('.scrollable').has($(e.target)).length
      e.preventDefault()
  )