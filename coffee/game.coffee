bootState =
    create: ->
        game.stage.backgroundColor = 0x008894
        
        game.scale.scaleMode = Phaser.ScaleManager.USER_SCALE;
        game.scale.setUserScale(3, 3);

        game.renderer.renderSession.roundPixels = true;
        Phaser.Canvas.setImageRenderingCrisp game.canvas
        
        game.physics.startSystem Phaser.Physics.ARCADE

        game.state.start 'load'

loadState =
    preload: ->
        loading = game.add.text game.world.centerX, game.world.centerY, ''
        loading.anchor.setTo 0.5, 0.5
        loading.text = 'loading'

        game.load.image 'wall', 'images/wall.gif'
        game.load.image 'player', 'images/player.gif'

    create: ->
        game.state.start 'play'

playState =
    create: ->
        @.cursorKeys = game.input.keyboard.createCursorKeys()
        @.jumpKey = game.input.keyboard.addKey Phaser.Keyboard.SPACEBAR
        
        @.createWorld()
        @.createPlayer()

    update: ->
        game.physics.arcade.collide @.player, @.walls

        @.movePlayer()

        unless @.player.inWorld then @.killPlayer()

    createWorld: ->
        @.walls = game.add.group()
        @.walls.enableBody = yes

        game.add.tileSprite 0, 0, 88, 2, 'wall', 0, @.walls
        game.add.tileSprite 168, 0, 88, 2, 'wall', 0, @.walls
        game.add.tileSprite 60, 60, 140, 2, 'wall', 0, @.walls        
        game.add.tileSprite 0, 120, 88, 2, 'wall', 0, @.walls
        game.add.tileSprite 168, 120, 88, 2, 'wall', 0, @.walls
        game.add.tileSprite 60, 180, 140, 2, 'wall', 0, @.walls
        game.add.tileSprite 0, 238, 88, 2, 'wall', 0, @.walls
        game.add.tileSprite 168, 238, 88, 2, 'wall', 0, @.walls
        game.add.tileSprite 0, 0, 2, 240, 'wall', 0, @.walls
        game.add.tileSprite 254, 0, 2, 240, 'wall', 0, @.walls

        @.walls.enableBody = yes
        @.walls.setAll 'body.immovable', yes

    createPlayer: ->
        @.player = game.add.sprite game.world.centerX, 0, 'player'
        @.player.anchor.setTo 0.5, 1

        game.physics.arcade.enable @.player
        @.player.body.gravity.y = 750

    movePlayer: ->
        if @.cursorKeys.left.isDown
            @.player.body.velocity.x = -150
        else if @.cursorKeys.right.isDown
            @.player.body.velocity.x = 150
        else
            @.player.body.velocity.x = 0
        
        if @.jumpKey.isDown and @.player.body.touching.down then @.player.body.velocity.y = -300

    killPlayer: ->
        game.state.start 'play'