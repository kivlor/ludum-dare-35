debugStyle = 
    font: "normal 10px Verdana"
    fill: '#fc589c'

scoreStyle = 
    font: "normal 12px Verdana"
    fill: '#ffffff'
    stroke: '#000000'
    strokeThickness: 2

textStyle = 
    font: "normal 18px Verdana"
    fill: '#ffffff'
    stroke: '#000000'
    strokeThickness: 4

bootState =
    create: ->
        # setup the game canvas
        game.scale.scaleMode = Phaser.ScaleManager.USER_SCALE;
        game.scale.setUserScale(2, 2);

        # make those pixels crisp
        game.renderer.renderSession.roundPixels = true;
        Phaser.Canvas.setImageRenderingCrisp game.canvas
            
        # add some physics
        game.physics.startSystem Phaser.Physics.ARCADE

        # colour and load!
        game.stage.backgroundColor = 0xFCD884
        game.state.start 'load'

loadState =
    preload: ->
        # add the loading text
        x = game.world.centerX
        y = game.world.centerY
        
        loading = game.add.text x, y, 'loading...', textStyle
        loading.anchor.setTo 0.5, 0.5

        # sprites
        game.load.spritesheet 'terrain', 'images/terrain.png', 256, 48
        game.load.spritesheet 'vehicle', 'images/vehicle.png', 24, 48
        game.load.spritesheet 'obstacle', 'images/obstacle.png', 32, 32

        # audio
        game.load.audio 'running', 'audio/running.mp3'
        game.load.audio 'shift', 'audio/shift.mp3'
        game.load.audio 'crash', 'audio/crash.mp3'

    create: ->
        game.state.start 'menu'

menuState =
    create: ->
        # add the get ready text
        x = game.world.centerX
        y = game.world.centerY

        ready = game.add.text x, y, 'spacebar to start', textStyle
        ready.anchor.setTo 0.5, 0.5
        
        # add the spacebar input
        spacebar = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
        spacebar.onDown.addOnce => game.state.start 'play'

playState =
    init: ->
        # smaller var names are smaller
        @SECOND = Phaser.Timer.SECOND

        # set some initial vars
        @speed = 4
        @score = 0
        @scorer = null
        @timer = game.time.create()

        # create the terrain data
        @terrainData =
            land:
                name: 'land'
                vehicle: 'car'
                obstacle: 1
            sea:
                name: 'sea'
                vehicle: 'boat'
                obstacle: 2
            air:
                name: 'air'
                vehicle: 'plane'
                obstacle: 3
        
        @terrainNames = ['land', 'sea', 'air']

        # use land for the default terrain
        @currentTerrain = @terrainData.land

    create: ->
        # setup the inputs
        @cursorKeys = game.input.keyboard.createCursorKeys()

        # add the sounds
        @runningSound = game.add.audio 'running'
        @crashSound = game.add.audio 'crash'
        @shiftSound = game.add.audio 'shift'

        # setup the layers (groups)
        @terrainLayer = game.add.group()
        @objectLayer = game.add.group()
        @playerLayer = game.add.group()
        @overlayLayer = game.add.group()

        # create the player and terrains
        @createPlayer()
        @createTerrains()

        # start the timers
        @createObstacleTimer()
        @createShiftTimer()

        @timer.start()

        # add the scorer text
        @scorer = game.add.text 4, 220, @score, scoreStyle

    update: ->
        # make sure the player isn't dead first
        unless @player.isAlive then return

        # collide player with bad terrain
        game.physics.arcade.overlap @player, @terrainLayer,
            (player, terrain) =>
                if @player.vehicle isnt terrain.vehicle then @killPlayer()
            (player, terrain) =>
                # we only care about the upcoming terrain
                if terrain.name isnt @currentTerrain.name then return no

                # get bottom y of both
                playerY = player.position.y + 24
                terrainY = terrain.position.y + 480

                # if player y is larger then they all in
                unless playerY < terrainY then return no else return yes

        # collide player with objects
        game.physics.arcade.overlap @player, @objectLayer, (player, object) =>
            if object.type is 'obstacle'
                @killPlayer()
            else
                @shiftPlayer()

        # move things around
        @movePlayer()
        @moveTerrains()
        @moveObjects()

        # update the score
        @updateScore()

    createObstacleTimer: ->
        @timer.loop @SECOND*2.5, =>
            @createObstacle()

    createShiftTimer: ->
        @timer.loop @SECOND*8, =>
            # shift the terrain over
            @shiftTerrains()

            # add the shifter tile
            @createShifter()

    createTerrains: ->
        # count for frame
        frame = 0

        # loop terrain data
        for index, data of @terrainData
            # first in, best dressed
            y = unless index is @currentTerrain.name then -480 else -240

            # create the terrain sprite
            terrain = game.add.tileSprite 0, y, 256, 480, 'terrain', frame
            game.physics.arcade.enable terrain

            # attach details to the terrain
            terrain.name = data.name
            terrain.vehicle = data.vehicle
            terrain.obstacles = data.obstacles

            # attach the terrain to the terrain layer
            @terrainLayer.add terrain

            # increment the frame
            frame++

    shiftTerrains: ->
        # decide next terrain
        next = game.rnd.pick @terrainNames
        next = game.rnd.pick @terrainNames while next is @currentTerrain.name

        # change current terrain
        @currentTerrain = @terrainData[next]

    moveTerrains: ->
        # loop the objects
        @terrainLayer.forEach (terrain) =>
            if terrain.name is @currentTerrain.name
                if terrain.position.y < 0
                    terrain.position.y = terrain.position.y + @speed
                else
                    terrain.position.y = -240
            else if terrain.position.y > -480
                if terrain.position.y < 240
                    terrain.position.y = terrain.position.y + @speed
                else
                    terrain.position.y = -480

    createPlayer: ->
        # create the player sprite
        @player = game.add.sprite game.world.centerX, 206, 'vehicle'
        @player.isAlive = yes
        @player.anchor.setTo 0.5, 0.5
        game.physics.arcade.enable @player

        # add frames
        @player.animations.add 'car', [0], 1, yes
        @player.animations.add 'boat', [1], 1, yes
        @player.animations.add 'plane', [2], 1, yes
        
        # set current vehicle
        @player.animations.play @currentTerrain.vehicle
        @player.vehicle = @currentTerrain.vehicle

        # attach the player layer
        @playerLayer.add @player

        # play the running sound
        @runningSound.loopFull()

    movePlayer: ->
        # dead players don't move
        unless @player.isAlive then return

        # up and down movement
        if @cursorKeys.up.isDown and @player.position.y > 36
            @player.body.velocity.y = -160
        else if @cursorKeys.down.isDown and @player.position.y < 206
            @player.body.velocity.y = 160
        else
            @player.body.velocity.y = 0

        # left and right movement
        if @cursorKeys.left.isDown and @player.position.x > 56
            @player.body.velocity.x = -160
        else if @cursorKeys.right.isDown and @player.position.x < 200
            @player.body.velocity.x = 160  
        else
            @player.body.velocity.x = 0

    killPlayer: ->
        # stop the timers
        @timer.removeAll()
        @timer.stop()

        # kill the player
        @player.isAlive = no
        @player.body.velocity.x = 0
        @player.body.velocity.y = 0
        @runningSound.stop()

        # play the crash sound
        @crashSound.play()

        # add the reset text
        # add the loading text
        x = game.world.centerX
        y = game.world.centerY
        
        reset = game.add.text x, y, 'spacebar to restart', textStyle
        reset.anchor.setTo 0.5, 0.5

        # add the spacebar input
        spacebar = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
        spacebar.onDown.addOnce => game.state.start 'play'

    shiftPlayer: ->
        # only needs to happen once
        unless @player.vehicle isnt @currentTerrain.vehicle then return

        # switch player frame to terrain frame
        @player.animations.play @currentTerrain.vehicle
        @player.vehicle = @currentTerrain.vehicle

        # play shitf song
        @shiftSound.play()

    createShifter: ->
        # randomly decide the x position
        x = game.rnd.pick [40, 88, 136, 184]

        # y position should be between terrains
        y = -16

        # create the shifter
        object = game.add.sprite x, y, 'obstacle', 0
        object.type = 'shifter'
        game.physics.arcade.enable object

        # add to object layer
        @objectLayer.add object

    createObstacle: ->
        # randomly decide the x position
        x = game.rnd.pick [40, 88, 136, 184]

        # create the object
        object = game.add.sprite x, -32, 'obstacle', @currentTerrain.obstacle
        object.type = 'obstacle'
        game.physics.arcade.enable object
        
        # add to object layer
        @objectLayer.add object

    moveObjects: ->
        # no point moving nothing
        unless @objectLayer.length > 0 then return

        # loop the objects
        @objectLayer.forEach (object) =>
            if object.position.y > 240
                object.destroy()
            else
                object.position.y += @.speed

    updateScore: ->
        @score++
        @scorer.text = Math.floor @score/4