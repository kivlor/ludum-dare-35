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
        loading = game.add.text game.world.centerX, game.world.centerY, ''
        loading.anchor.setTo 0.5, 0.5
        loading.text = 'loading...'

        # terrain
        game.load.image 'land', '/images/land.png'
        game.load.image 'sea', '/images/sea.png'
        game.load.image 'air', '/images/air.png'

        # objects
        game.load.image 'barricade', '/images/barricade.png'
        game.load.image 'shifter', '/images/shifter.png'

        # vehicle
        game.load.spritesheet 'vehicle', '/images/vehicle.png', 24, 48

        # audio
        game.load.audio 'running', 'audio/running.mp3'
        game.load.audio 'shift', 'audio/shift.mp3'
        game.load.audio 'crash', 'audio/crash.mp3'

    create: ->
        game.state.start 'menu'

menuState =
    create: ->
        # add the get ready text
        ready = game.add.text game.world.centerX, game.world.centerY
        ready.anchor.setTo 0.5, 0.5
        ready.text = 'spacebar to start'

        # add the spacebar input
        spacebar = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
        spacebar.onDown.addOnce => game.state.start 'play'

playState =
    init: ->
        # smaller var names are smaller
        @SECOND = Phaser.Timer.SECOND

        # set some initial vars
        @speed = 4
        @timer = game.time.create()

        # create the track data
        @trackData =
            land:
                name: 'land'
                vehicle: 'car'
                obstacles: ['barricade']
            sea:
                name: 'sea'
                vehicle: 'boat'
                obstacles: ['barricade']
        
        @trackNames = ['land', 'sea']

        # use land for the default track
        @currentTerrain = @trackData.land

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

        # create the player and tracks
        @createPlayer()
        @createTerrains()

        # start the timers
        # @createObjectTimer()
        @createShiftTimer()

        @timer.start()

    update: ->
        # make sure the player isn't dead first
        unless @player.isAlive then return

        # collide player with bad terrain
        game.physics.arcade.overlap @player, @terrainLayer,
            (player, terrain) =>
                if @player.vehicle isnt terrain.vehicle then @killPlayer()
            (player, terrain) =>
                # we only care about the upcoming track
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

    createObjectTimer: ->
        @timer.loop @SECOND*2, =>
            unless game.rnd.normal() is 0 then @createObject()

    createShiftTimer: ->
        @timer.loop @SECOND*5, =>
            # shift the track over
            @shiftTerrains()

            # add the shifter tile
            @createShifter()

    createTerrains: ->
        # loop track data
        for index, data of @trackData
            # first in, best dressed
            y = unless index is @currentTerrain.name then -480 else -240

            # create the track sprite
            track = game.add.tileSprite 0, y, 256, 480, data.name
            game.physics.arcade.enable track

            # attach details to the track
            track.name = data.name
            track.vehicle = data.vehicle
            track.obstacles = data.obstacles

            # attach the track to the terrain layer
            @terrainLayer.add track

    shiftTerrains: ->
        # decide next track
        next = game.rnd.pick @trackNames
        next = game.rnd.pick @trackNames while next is @currentTerrain.name

        # change current track
        @currentTerrain = @trackData[next]

    moveTerrains: ->
        # loop the objects
        @terrainLayer.forEach (track) =>
            if track.name is @currentTerrain.name
                if track.position.y < 0
                    track.position.y = track.position.y + @speed
                else
                    track.position.y = -240
            else if track.position.y > -480
                if track.position.y < 240
                    track.position.y = track.position.y + @speed
                else
                    track.position.y = -480

    createPlayer: ->
        # create the player sprite
        @player = game.add.sprite game.world.centerX, 206, 'vehicle'
        @player.isAlive = yes
        @player.anchor.setTo 0.5, 0.5
        game.physics.arcade.enable @player

        # add frames
        @player.animations.add 'car', [0], 1, yes
        @player.animations.add 'boat', [1], 1, yes
        
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
        reset = game.add.text game.world.centerX, game.world.centerY
        reset.anchor.setTo 0.5, 0.5
        reset.text = 'spacebar to retry'

        # add the spacebar input
        spacebar = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
        spacebar.onDown.addOnce => game.state.start 'play'

    shiftPlayer: ->
        # only needs to happen once
        unless @player.vehicle isnt @currentTerrain.vehicle then return

        # switch player frame to track frame
        @player.animations.play @currentTerrain.vehicle
        @player.vehicle = @currentTerrain.vehicle

        # play shitf song
        @shiftSound.play()

    createShifter: ->
        # randomly decide the x position
        x = game.rnd.pick [40, 88, 136, 184]

        # y position should be between terrains
        y = @currentTerrain

        # create the shifter
        object = game.add.sprite x, 8, 'shifter'
        object.type = 'shifter'
        game.physics.arcade.enable object

        # add to object layer
        @objectLayer.add object

    createObject: ->
        # randomly decide the x position
        x = game.rnd.pick [40, 88, 136, 184]

        # create the object
        object = game.add.sprite x, -16, 'barricade'
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
