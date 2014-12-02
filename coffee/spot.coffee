
class window.Spot

	constructor: ->
		@index = 0
		@spot = null

		next = game.input.keyboard.addKey(Phaser.Keyboard.A)
		next.onDown.add(this.nextSpot, this)

		this.nextSpot()

	update: ->
		@spot.update()

	attach: (player) ->
		@spot.player = player

	get_player_ghost: ->
		return @spot.player_ghost

	get_mouse_ghost: ->
		return @spot.mouse_ghost

	nextSpot: ->
		spots = [ Column, Ring ]
		@index = (@index + 1 ) % spots.length

		@spot = new spots[@index]

	showSpot: ->
		null


class window.Ring
	constructor: ->
		@max_width = 50
		@player_radius = @max_width
		@mouse_radius = 20

		@player_spot = game.add.graphics(0, 0)
		@player_ghost = game.add.graphics(0, 0)

		@mouse_spot = game.add.graphics(0, 0)
		@mouse_ghost = game.add.graphics(0, 0)

		this.init(@player_spot, @player_radius)
		this.init(@player_ghost, @player_radius)
		this.init(@mouse_spot, @mouse_radius)
		this.init(@mouse_ghost, @mouse_radius)

		@mouse_spot.scale = @mouse_ghost.scale =
			x: 0
			y: 0

		@mouse_spot.fixedToCamera = @mouse_ghost.fixedToCamera = true

		game.input.onDown.add(this.showSpot, this)
		game.input.onUp.add(this.hideSpot, this)

		@shake = false

	init: (graphic, radius) ->
		graphic.beginFill(0xffffff)
		graphic.drawCircle(0, 0, radius)


	update: ->
		if game.input.mousePointer.isDown
			if @player_radius > 0
				@player_radius -= 0.3

				@shake = (@player_radius < 30)

				delta = (@player_radius / @max_width)
				@player_spot.scale = @player_ghost.scale =
					x: delta
					y: delta

		else
			if @player_radius < @max_width
				@player_radius += 0.3
				delta = (@player_radius / @max_width)
				@player_spot.scale = @player_ghost.scale =
					x: delta
					y: delta


		@player_spot.x = @player_ghost.x = @player.x
		@player_spot.y = @player_ghost.y = @player.y

		px = game.input.x
		py = game.input.y

		if @shake
			px += 1 * Phaser.Math.randomSign()
			py += 1 * Phaser.Math.randomSign()

		@mouse_spot.cameraOffset.setTo(px, py)
		@mouse_ghost.cameraOffset.setTo(px, py)

	showSpot: ->
		game.add.tween(@mouse_spot.scale).to({x: 1, y: 1}, 100).start()

	hideSpot: ->
		game.add.tween(@mouse_spot.scale).to({x: 0, y: 0}, 100).start()


class window.Column
	constructor: ->
		@max_width = 80
		@player_width = @max_width
		@step = 3

		@player_spot = game.add.graphics(0, 0)
		@player_ghost = game.add.graphics(0, 0)

		@mouse_spot = game.add.graphics(0, 0)
		@mouse_ghost = game.add.graphics(0, 0)

		this.init(@player_spot)
		this.init(@player_ghost)
		this.init(@mouse_spot)
		this.init(@mouse_ghost)

		@mouse_spot.scale = @mouse_ghost.scale =
			x: 0

		@mouse_spot.fixedToCamera = @mouse_ghost.fixedToCamera = true

	init: (graphic) ->
		graphic.beginFill(0xffffff)
		graphic.drawRect(-(@max_width / 2), 0, @max_width, game.height)


	update: ->
		if game.input.mousePointer.isDown
			if @player_width > 0
				@player_width -= @step
				@player_width = 0 if @player_width < 0

				delta = (@player_width / @max_width)
				oppos = 1 - delta

				@player_spot.scale = @player_ghost.scale =
					x: delta
					y: 1

				@mouse_spot.scale = @mouse_ghost.scale =
					x: oppos
					y: 1
		else
			if @player_width < @max_width
				@player_width += @step
				@player_width = @max_width if @player_width > @max_width

				delta = (@player_width / @max_width)
				oppos = 1 - delta

				@player_spot.scale = @player_ghost.scale =
					x: delta
					y: 1

				@mouse_spot.scale = @mouse_ghost.scale =
					x: oppos
					y: 1

		@player_spot.x = @player_ghost.x = @player.x
		#@player_spot.y = @player_ghost.y = @player.y

		@mouse_spot.cameraOffset.setTo(game.input.x, 0)
		@mouse_ghost.cameraOffset.setTo(game.input.x, 0)
