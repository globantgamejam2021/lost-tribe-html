intGame = null
timeRemaining = 0

level = 0
levels = [7]

shuffle = (array) -> array.sort -> .5 - Math.random()
characters = Array.from Array(10).keys()
characters.shift()

jQuery ($) ->
	$('.screen').hide()
	$('.screen.collection').fadeIn()
	# Prevent user from dragging images, because it sucks
	$('img'). on 'dragstart', (e) ->
		e.preventDefault()
		e.stopPropagation()
		false

	tick = () ->
		timeRemaining -= 1
		if timeRemaining <= 0 
			alert('Game Over')
			clearInterval(intGame)
			intGame = null
			return
		$('.timer-a').text(timeRemaining)
		$('.timer-b').text(timeRemaining)

	$('.wrap').on 'click', (e) ->
		if $(@).attr('data-character') == levels[level].toString()
			win()
		else
			timeRemaining = Math.floor(timeRemaining / 2)
			tick()

	win = () ->
		alert("Ganó")
		localStorage.setItem("level", ++level)
		resetLevel()

	resetLevel = () ->
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
			$('.screen.level-select').fadeIn()
		)

	$('.level-select .start').on 'mouseup', (e) ->
		$.when($('.screen').fadeOut()).then(->
			level = localStorage.getItem('level') or 0
			resetLevel()
			$('.screen.main').fadeIn()
		)
