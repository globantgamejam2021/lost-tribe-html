characters = []
intGame = null
timeRemaining = 0

jQuery ($) ->
  $('.screen').hide()
  $('.screen.title').show()
  # prevent user from dragging images, because it sucks
  $('img'). on 'dragstart', (e) ->
    e.preventDefault()
    e.stopPropagation()
    false

  tick = ()->
    timeRemaining--
    $('.timer-a').text(timeRemaining)
    $('.timer-b').text(timeRemaining)
    if timeRemaining < 0 
      # alert('game over')
      clearInterval(intGame)
      intGame = null

  #main menu handling
  $('.start').on 'mousedown', (e) -> $(@).addClass('clicked')
  $('html').on 'mouseup', (e) -> $('.start').removeClass('clicked')
  $('.title .start').on 'mouseup', (e) ->
    $.when($('.screen').fadeOut()).then(->
      $('.screen.tutorial').fadeIn()
    )

  $('.tutorial .start').on 'mouseup', (e) ->
    $.when($('.screen').fadeOut()).then(->
      $('.screen.main').fadeIn()
    )
    timeRemaining = 31
    tick()
    intGame = setInterval(tick, 1000)