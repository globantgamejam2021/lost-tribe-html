intGame = null
timeRemaining = 0

level = 0
levels = [7]

shuffle = (array) -> array.sort -> .5 - Math.random()
characters = Array.from Array(10).keys()
characters.shift()

jQuery ($) ->
  $('.screen').hide()
  $('.screen.title').fadeIn()
  # prevent user from dragging images, because it sucks
  $('img'). on 'dragstart', (e) ->
    e.preventDefault()
    e.stopPropagation()
    false

  tick = ()->
    timeRemaining--
    if timeRemaining < 0 
      alert('game over')
      clearInterval(intGame)
      intGame = null
      return
    $('.timer-a').text(timeRemaining)
    $('.timer-b').text(timeRemaining)

  $('.wrap').on 'click', (e) ->
    if $(@).attr('data-character') == levels[level].toString()
      alert("Gano")
    else
      timeRemaining = Math.floor(timeRemaining / 2)
      tick()

  resetLevel = ()->
    if intGame
      intGame = null
      clearInterval intGame
    characters = shuffle(characters)

    $('.wrap').each (index, element)->
      $(@).attr('data-character', characters[index])
      $(@).find('.character').css('background-image', "url('../img/character-level#{("00"+(level+1)).substr(-2)}-#{("00"+characters[index]).substr(-2)}.gif')")
    timeRemaining = 31
    tick()
    intGame = setInterval(tick, 1000)

  #main menu handling
  $('.start').on 'mousedown', (e) -> $(@).addClass('clicked')
  $('html').on 'mouseup', (e) -> $('.start').removeClass('clicked')
  $('.title .start').on 'mouseup', (e) ->
    $.when($('.screen').fadeOut()).then(->
      $('.screen.tutorial').fadeIn()
    )

  $('.tutorial .start').on 'mouseup', (e) ->
    $.when($('.screen').fadeOut()).then(->
      level = 0
      resetLevel()
      $('.screen.main').fadeIn()
    )
  # level = 0
  # resetLevel()