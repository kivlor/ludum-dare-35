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
        loading.text = 'loading'

        game.load.image 'land', '/images/land.png'
        game.load.image 'sea', '/images/sea.png'
        game.load.image 'air', '/images/air.png'
        game.load.image 'vehicle', '/images/vehicle.png'

    create: ->
        game.state.start 'play'

playState =
    init: ->
        # set initial vars
        @.speed = 2
        @.objects = []

    create: ->
        # set cursor keys
        @.cursorKeys = game.input.keyboard.createCursorKeys()
        @.jumpKey = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR

        # start the speed and object timers
        @.createSpeedTimer()
        @.createObjectTimer()

        # create the track and player
        @.createTrack()
        @.createPlayer()

    update: ->
        # move things around
        @.moveTrack()
        @.movePlayer()
        @.moveObjects()

        # collide things

    createSpeedTimer: ->
    createObjectTimer: ->

    createTrack: -> @.track = game.add.tileSprite 0, -240, 256, 240*2, 'land'

    moveTrack: ->
        # manually moving the track 'down' cause physics was hard :/
        if @.track.position.y < 0
            @.track.position.y += @.speed
        else
            @.track.position.y = -240

    createPlayer: ->
        @.player = game.add.sprite game.world.centerX, 206, 'vehicle'
        @.player.anchor.setTo 0.5, 0.5
        game.physics.arcade.enable @.player

    movePlayer: ->
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

    createObject: ->

    moveObjects: ->