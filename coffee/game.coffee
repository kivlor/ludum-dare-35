bootState =
    create: ->
        game.stage.backgroundColor = 0xbcc0c4
        
        game.scale.scaleMode = Phaser.ScaleManager.USER_SCALE;
        game.scale.setUserScale(2, 2);

        game.renderer.renderSession.roundPixels = true;
        Phaser.Canvas.setImageRenderingCrisp game.canvas
        
        game.physics.startSystem Phaser.Physics.ARCADE

        game.state.start 'load'

loadState =
    preload: ->
        loading = game.add.text game.world.centerX, game.world.centerY, ''
        loading.anchor.setTo 0.5, 0.5
        loading.text = 'loading...'

        # terrain
        game.load.image 'land', '/images/land.png'
        game.load.image 'sea', '/images/sea.png'
        game.load.image 'air', '/images/air.png'

        # objects
        game.load.image 'barricade', '/images/barricade.png'
        game.load.image 'shift', '/images/shift.png'

        # vehicles
        game.load.image 'car', '/images/car.png'
        game.load.image 'boat', '/images/boat.png'

    create: ->
        game.state.start 'play'

playState =
    init: ->
        # set initial vars
        @.speed = 3
        @.speedTimer = null

        @.objects = []
        @.objectTimer = null
        
        @.trackTimer = null

    create: ->
        # set cursor keys
        @.cursorKeys = game.input.keyboard.createCursorKeys()
        @.jumpKey = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR

        # setup the layers (groups)
        @.terrainLayer = game.add.group()
        @.objectLayer = game.add.group()
        @.playerLayer = game.add.group()
        @.overlayLayer = game.add.group()

        # create the track and player
        @.createTrack()
        @.createPlayer()

        # start the timers
        @.createSpeedTimer()
        @.createObjectTimer()
        @.createTrackTimer()

    update: ->
        # collide things
        game.physics.arcade.overlap @.player, @.objectLayer, => @.killPlayer()

        # move things around
        @.moveTrack()
        @.movePlayer()
        @.moveObjects()

        # listen for revive
        @.revivePlayer()

    createSpeedTimer: ->
        @.speedTimer = game.time.events.loop Phaser.Timer.SECOND*10, =>
            unless @.speed is 6 then @.speed++

    createObjectTimer: ->
        @.objectTimer = game.time.events.loop Phaser.Timer.SECOND*2, =>
            unless game.rnd.normal() is 0 then @.createObject()

    createTrackTimer: ->
        @.trackTimer = game.time.events.loop Phaser.Timer.SECOND*15, =>
            @.switchTrack()

    createTrack: ->
        @.track = game.add.tileSprite 0, -240, 256, 240*2, 'land'

        @.terrainLayer.add @.track

    moveTrack: ->
        # manually moving the track 'down' cause physics was hard :/
        if @.track.position.y < 0
            @.track.position.y += @.speed
        else
            @.track.position.y = -240

    createPlayer: ->
        @.player = game.add.sprite game.world.centerX, 206, 'car'
        @.player.anchor.setTo 0.5, 0.5
        game.physics.arcade.enable @.player

        @.playerLayer.add @.player

    movePlayer: ->
        # can't move a dead player
        unless @.player.alive is true then return 

        # up and down movement
        if @.cursorKeys.up.isDown and @.player.position.y > 36
            @.player.body.velocity.y = -160
        else if @.cursorKeys.down.isDown and @.player.position.y < 206
            @.player.body.velocity.y = 160
        else
            @.player.body.velocity.y = 0

        # left and right movement
        if @.cursorKeys.left.isDown and @.player.position.x > 56
            @.player.body.velocity.x = -160
        else if @.cursorKeys.right.isDown and @.player.position.x < 200
            @.player.body.velocity.x = 160  
        else
            @.player.body.velocity.x = 0        

    killPlayer: ->
        # kill the player
        @.player.alive = no
        @.player.body.velocity.x = 0
        @.player.body.velocity.y = 0
        
        # set the game speed to 0
        @.speed = 0

        # stop the timers
        game.time.events.remove @.speedTimer
        game.time.events.remove @.objectTimer

        # show the game over text
        retry = game.add.text game.world.centerX, game.world.centerY, ''
        retry.anchor.setTo 0.5, 0.5
        retry.text = 'spacebar to retry'

        @.overlayLayer.add retry

    revivePlayer: ->
        # can't move a revive what isn't dead
        unless @.player.alive is false then return

        if @.jumpKey.isDown then game.state.start 'play'

    createObject: ->
        # randomly decide the x position
        x = game.rnd.pick [40, 88, 136, 184]

        # create the object
        object = game.add.sprite x, -16, 'barricade'
        object.type = 'obstacle'
        game.physics.arcade.enable object
        
        # add to object layer
        @.objectLayer.add object

    moveObjects: ->
        # no point moving nothing
        unless @.objectLayer.length > 0 then return

        # loop the objects
        @.objectLayer.forEach (child) =>
            if child.position.y > 240 
                child.destroy
            else
                child.position.y += @.speed

    createShifter: ->
        # randomly decide the x position
        x = game.rnd.pick [40, 88, 136, 184]

        # create the shifter
        object = game.add.sprite x, -16, 'shifter'
        object.type = 'shifter'
        game.physics.arcade.enable object

        # add to object layer
        @.objectLayer.add object
        