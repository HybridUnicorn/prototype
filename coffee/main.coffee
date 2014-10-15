
window.TINT_BEG = 0x00B5B9


do ->
	window.game = new Phaser.Game(480, 320, Phaser.CANVAS, "game", null, false, true)
	game.state.add("main", mainState)
	game.state.start("main")

