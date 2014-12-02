window.mainState =
	preload: ->

		# Map
		for map in [
			"map1"
		]
			game.load.tilemap(map, "assets/levels/#{map}.json", null, Phaser.Tilemap.TILED_JSON)
			game.load.image(map, "assets/levels/#{map}.png")


		# Sprites
		for sprite in [
			"player"
			"platform"
			"peak"
			"long_peak"
		]
			game.load.image(sprite, "assets/sprites/#{sprite}.png")


	create: ->

		# Game
		game.stage.backgroundColor = TINT_BEG
		game.physics.startSystem Phaser.Physics.ARCADE

		# Spot
		@spots = new Spot()

		# Player
		@player = game.add.sprite(80, 160, "player")
		game.physics.arcade.enable @player
		@player.body.gravity.y = 980
		@player.anchor.setTo 0.5, 0.5
		@player.tint = TINT_BEG
		@player.checkWorldBounds = true
		@player.events.onOutOfBounds.add(this.die, this)
		@cursor = game.input.keyboard.createCursorKeys()
		game.camera.follow @player

		# Spots' callback for player
		@spots.attach(@player)

		# Map data
		@map = game.add.tilemap("map1")

		@layer = @map.createLayer("level")
		@layer.resizeWorld()
		@map.setCollision 1
		game.world.setBounds 0, 0, @map.widthInPixels, @map.heightInPixels

		# Map sprite
		@world = game.add.sprite(0, 0, "map1")
		@world.tint = TINT_BEG

		# Peak
		@peaks = game.add.group()
		@peaks_mouse = game.add.group()
		@peaks.enableBody = true
		@peaks_mouse.enableBody = true
		@map.createFromObjects "object", 2, "peak", 0, true, false, @peaks
		@map.createFromObjects "object", 4, "long_peak", 0, true, false, @peaks
		@peaks.forEach ((peak) ->
			@peaks_mouse.create peak.x, peak.y, peak.key
			return
		), this
		@peaks.setAll "tint", (0xffffff - TINT_BEG)
		@peaks_mouse.setAll "tint", (0xffffff - TINT_BEG)

		# Peaks's mask from spot ghost
		@peaks.mask = @spots.get_player_ghost()
		@peaks_mouse.mask = @spots.get_mouse_ghost()

		# Plateform
		@plateforms = game.add.group()
		@plateforms.enableBody = true
		@map.createFromObjects "object", 3, null, 0, true, false, @plateforms, Platform

		@plateforms.setAll "body.immovable", true
		@plateforms.setAll "tint", TINT_BEG


	update: ->
		game.physics.arcade.collide @player, @layer
		game.physics.arcade.collide @player, @plateforms
		game.physics.arcade.overlap @player, @peaks, @die, null, this
		@movePlayer()
		@spots.update()


	movePlayer: ->
		if @cursor.left.isDown
			@player.body.velocity.x = -200
		else if @cursor.right.isDown
			@player.body.velocity.x = 200
		else
			@player.body.velocity.x = 0

		if @cursor.up.isDown and (@player.body.onFloor() or @player.body.touching.down)
			@player.body.velocity.y = -420


	die: ->
		game.state.start "main"
