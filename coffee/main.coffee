
window.TINT_BEG = 0x00B5B9

RENDERER = Phaser.AUTO

isBrowser = (name) ->
	val = navigator.userAgent.toLowerCase()
	if val.indexOf(name) > -1
		return true
	return false

if isBrowser("firefox")
	RENDERER = Phaser.CANVAS

do ->
	window.game = new Phaser.Game(480, 320, RENDERER, "game", null, false, true)
	game.state.add("main", mainState)
	game.state.start("main")

