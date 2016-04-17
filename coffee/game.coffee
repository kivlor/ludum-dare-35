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

    create: ->
        game.state.start 'menu'

menuState =
    init: ->
        @TEXT = 'spacebar to start'

    create: ->
        # add the get ready text
        ready = game.add.text game.world.centerX, game.world.centerY
        ready.anchor.setTo 0.5, 0.5
        ready.text = @TEXT

        # add the spacebar input
        spacebar = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
        spacebar.onDown.addOnce => game.state.start 'play'

playState =
    init: ->
        # smaller var names are smaller
        @SECOND = Phaser.Timer.SECOND

        # set initial game speed
        @speed = 4

        # and setup all the timers
        @speedTimer = null
        @objectTimer = null
        @trackTimer = null

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
        @currentTrack = @trackData.land

    create: ->
        # setup the inputs
        @cursorKeys = game.input.keyboard.createCursorKeys()
        @resetKey = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR

        # setup the layers (groups)
        @terrainLayer = game.add.group()
        @objectLayer = game.add.group()
        @playerLayer = game.add.group()
        @overlayLayer = game.add.group()

        # create the player and tracks
        @createPlayer()
        @createTracks()

        # start the timers
        # @createSpeedTimer()
        @createObjectTimer()
        @createShiftTimer()

    update: ->
        # move things around
        @movePlayer()
        @moveTracks()
        @moveObjects()

        # collide things
        game.physics.arcade.overlap @player, @objectLayer, (player, object) =>
            if object.type is 'obstacle'
                @killPlayer()
            else
                @shiftPlayer()

        #game.physics.arcade.overlap @player, @terrainLayer, (player, terrain) =>

    createSpeedTimer: ->
        @speedTimer = game.time.events.loop @SECOND*10, =>
            unless @speed is 6 then @speed++

    createObjectTimer: ->
        @objectTimer = game.time.events.loop @SECOND*2, =>
            unless game.rnd.normal() is 0 then @createObject()

    createShiftTimer: ->
        @trackTimer = game.time.events.loop @SECOND*5, =>
            # add the shifter tile
            @createShifter()

            # shift the track over
            @shiftTracks()

    createTracks: ->
        # loop track data
        for index, data of @trackData
            # first in, best dressed
            y = unless index is @currentTrack.name then -480 else -240

            # create the track sprite
            track = game.add.tileSprite 0, y, 256, 480, data.name
            
            # attach details to the track
            track.name = data.name
            track.vehicle = data.vehicle
            track.obstacles = data.obstacles

            # attach the track to the terrain layer
            @terrainLayer.add track

    shiftTracks: ->
        # decide next track
        next = game.rnd.pick @trackNames
        next = game.rnd.pick @trackNames while next is @currentTrack.name

        # change current track
        @currentTrack = @trackData[next]

    moveTracks: ->
        # loop the objects
        @terrainLayer.forEach (track) =>
            if track.name is @currentTrack.name
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
        @player.anchor.setTo 0.5, 0.5
        game.physics.arcade.enable @player

        # add frames
        @.player.animations.add 'car', [0], 1, yes
        @.player.animations.add 'boat', [1], 1, yes
        @.player.animations.play

        # attach the player layer
        @playerLayer.add @player

    movePlayer: ->
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
        # back to menu state
        game.state.start 'menu'

    shiftPlayer: ->
        # switch player frame to track frame
        @player.animations.play @currentTrack.vehicle

    createShifter: ->
        # randomly decide the x position
        x = game.rnd.pick [40, 88, 136, 184]

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
