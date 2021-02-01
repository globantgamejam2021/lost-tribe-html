intGame = null
timeRemaining = 0

level = 0
levels = [7,9]

shuffle = (array) -> array.sort -> .5 - Math.random()
characters = Array.from Array(10).keys()
characters.shift()

sounds = {}
sounds.title = new Audio('../assets/title.mp3')

sounds.correct = new Audio('../assets/gamejam-correct-largo.mp3')
sounds.wrong = new Audio('../assets/gamejam-wrong-v2.mp3')
sounds.bgm = new Audio('../assets/gamejam-level.mp3')
sounds.win = new Audio('../assets/youwin.mp3')

sounds.countdown = []
sounds.countdown.push(new Audio('../assets/gameover.mp3'))
sounds.countdown.push(new Audio('../assets/c1.mp3'))
sounds.countdown.push(new Audio('../assets/c2.mp3'))
sounds.countdown.push(new Audio('../assets/c3.mp3'))
sounds.countdown.push(new Audio('../assets/c4.mp3'))
sounds.countdown.push(new Audio('../assets/c5.mp3'))

sounds.bgm.volume = 0.5
sounds.title.volume = 0.5
sounds.title.loop = true
play = (a) ->
  a.currentTime = 0
  a.play()

jQuery ($) ->
  $('.screen').hide()
  $('.screen.title').fadeIn()
  sounds.title.play()
  # Prevent user from dragging images, because it sucks
  $('img'). on 'dragstart', (e) ->
    e.preventDefault()
    e.stopPropagation()
    false

  tick = () ->
    timeRemaining -= 1
    if timeRemaining <= 0 
      play(sounds.countdown[0]) if (sounds.countdown[0])
      clearInterval(intGame)
      level=0
      intGame = null
      $.when($('.screen').fadeOut()).then(->
        sounds.bgm.pause()
        sounds.title.play()
        $('.screen.title').fadeIn()
      )
      return
    play(sounds.countdown[timeRemaining]) if (sounds.countdown[timeRemaining])

    $('.timer-a').text(timeRemaining)
    $('.timer-b').text(timeRemaining)

  $('.wrap').on 'click', (e) ->
    if $(@).attr('data-character') == levels[level].toString()
      win()
    else
      play(sounds.wrong)
      timeRemaining = Math.floor(timeRemaining / 2)
      tick()
      sounds.bgm.currentTime = 30-timeRemaining

  win = () ->
    play(sounds.correct)
    $.when($('.screen').fadeOut()).then(->
      level=level+1
      if level > 1
        play(sounds.win)
        clearInterval(intGame)
        level=0
        intGame = null
        sounds.bgm.pause()
        sounds.title.play()
        $('.screen.title').fadeIn()
        return

      resetLevel()
      $('.screen.main').fadeIn()
    )

  resetLevel = () ->
    play(sounds.bgm)
    if intGame
      clearInterval intGame
      intGame = null
    characters = shuffle(characters)

    $('.wrap').each (index, element) ->
      $(@).attr('data-character', characters[index])
      $(@).find('.character').css('background-image', "url('../img/character-level#{("00"+(level+1)).substr(-2)}-#{("00"+characters[index]).substr(-2)}.gif')")
    timeRemaining = 31
    tick()
    intGame = setInterval(tick, 1000)

  # Main menu handling
  $('.start').on 'mousedown', (e) -> $(@).addClass('clicked')
  $('html').on 'mouseup', (e) -> $('.start').removeClass('clicked')

  $('.title .start').on 'mouseup', (e) ->
    $.when($('.screen').fadeOut()).then(->
      $('.screen.tutorial').fadeIn()
    )

  $('.tutorial .start').on 'mouseup', (e) ->
    $.when($('.screen').fadeOut()).then(->
      level = 0 #(localStorage.getItem('level') or 0)/1
      resetLevel()
      sounds.title.pause()
      $('.screen.main').fadeIn()
    )

  # $('.level-select .start').on 'mouseup', (e) ->
  # 	$.when($('.screen').fadeOut()).then(->
  # 		level = localStorage.getItem('level') or 0
  # 		resetLevel()
  # 		$('.screen.main').fadeIn()
  # 	)
