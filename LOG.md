## Development Log

### 16/04/2105

#### 11:03

Theme anounced as shapeshifting! So far my ideas are a racer where to progress
you need to shape shift into different vehicles and a platform where you have to
shape shift into different animals/creatures...

#### 11:13

Sold on the race idea. Simple to create land/sea/air vehicles... Going for a
walk to get supplies and think about it a bit more.

#### 11:46

Alright, the supply run helped heaps! Definatly sticking to the morphing racer
idea. I think it'll be easiest to create it as an infinate runner that way I
don't have to implement competitiors or anything. During polish I could possibly
hook up a leader board or something but we'll see.

The idea will be before the transition between each course type the player has
to hit a morph plate or something. There will also be obstacles the player has
to avoid (oil on the road, rocks in the sea, birds in the air).

I also had the idea that the air vehicle could be OP in that it'll work over
air, sea or land... maybe I could work that into the game play.

#### 12:11

Been doodleing ideas in PS Sketch, going to start coding some of the primitives.

#### 13:14

Ended up spending too much time in PS mocking up land, air and sea backgrounds
plus a dodgy vehicle. Going to have lunch then bring them into the game load and
see if I can make a really basic game race track.

#### 14:54

Haven't made too much progress on anything really. I have the game loading a
tile sprite that makes up the road. The road has gravity applied so it falls
down and when it's y position hits 0 it gets reset. Problem is over time the
velocity ramps up and it becomes a blur 😳

I'm going to go make a coffee and think about the road a little more. My 
current idea is to 'manually' update the road posistion each cycle but that's
going to take some time to implement.

#### 15:33

OMG, progress! I've the track moving and reseting and I've added the initial
vehicle. There's a 'bump' when the track move back to it's home postion but
that's fine for now.

Going to keep working on the track, next step is to add the transition from one
track to the next.

#### 15:59

Urrrrgh, just realised why there was a bump in the transition! Turns out my game
height isn't evenly divisible by my tile height. Well then, I might have just
saved myself some time!

#### 16:57

Haven't made much progress code wise but I've been reading a bunch on Phaser's
timer functions. I'm planning on using them to slowly ramp up the speed as the
game progresses, switch 'tracks' and to spawn objects.