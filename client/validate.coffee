ISBN = @ISBN

@validate =
  ## ISBN validation ##
  isbn: (num) ->
    if ISBN.parse(num) then true else false