
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


class window.Ring
	constructor: ->
		@max_width = 60
		@player_width = @max_width
		@mouse_radius = 0

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
			y: 0

		@mouse_spot.fixedToCamera = @mouse_ghost.fixedToCamera = true

	init: (graphic) ->
		graphic.beginFill(0xffffff)
		graphic.drawCircle(0, 0, @max_width)


	update: ->
		if game.input.mousePointer.isDown
			if @player_width > 0
				@player_width -= 1.5

				#this.mouse_radius += 2
				delta = (@player_width / @max_width)
				oppos = 1 - delta
				@player_spot.scale = @player_ghost.scale =
					x: delta
					y: delta

				@mouse_spot.scale = @mouse_ghost.scale =
					x: oppos
					y: oppos
		else
			if @player_width < @max_width
				@player_width += 1.5
				delta = (@player_width / @max_width)
				oppos = 1 - delta
				@player_spot.scale = @player_ghost.scale =
					x: delta
					y: delta

				@mouse_spot.scale = @mouse_ghost.scale =
					x: oppos
					y: oppos

		@player_spot.x = @player_ghost.x = @player.x
		@player_spot.y = @player_ghost.y = @player.y

		@mouse_spot.cameraOffset.setTo(game.input.x, game.input.y)
		@mouse_ghost.cameraOffset.setTo(game.input.x, game.input.y)


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
