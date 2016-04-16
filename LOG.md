## Development Log

### 16/04/2105

#### 11:03

Theme announced as shapeshifting! So far my ideas are a racer where to progress
you need to shape shift into different vehicles and a platform where you have to
shape shift into different animals/creatures...

#### 11:13

Sold on the race idea. Simple to create land/sea/air vehicles... Going for a
walk to get supplies and think about it a bit more.

#### 11:46

Alright, the supply run helped heaps! Defiantly sticking to the morphing racer
idea. I think it'll be easiest to create it as an infinite runner that way I
don't have to implement competitions or anything. During polish I could possibly
hook up a leader board or something but we'll see.

The idea will be before the transition between each course type the player has
to hit a morph plate or something. There will also be obstacles the player has
to avoid (oil on the road, rocks in the sea, birds in the air).

I also had the idea that the air vehicle could be OP in that it'll work over
air, sea or land... maybe I could work that into the game play.

#### 12:11

Been doodling ideas in PS Sketch, going to start coding some of the primitives.

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
current idea is to 'manually' update the road position each cycle but that's
going to take some time to implement.

#### 15:33

OMG, progress! I've the track moving and reseting and I've added the initial
vehicle. There's a 'bump' when the track move back to it's home position but
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

#### 17:53

Tea time! I've got the speed increase timer implemented and I mocked up a test
object (a road barricade) to use with the object timer. I also started looking
at top down picture of boats and cars and did some sketches.

My goal tonight is to have the track switching every 5 - 10 seconds and the
vehicle morphing in place 😁

#### 18:22

I'm stuck on creating looping timers. My syntax looks correct and I'm not
getting any errors in the browser console but nothing is happening 😭 What's
worse is I can't move on because everything relies on timers. FML.

#### 18:30

Fuck me, timers are working! My habbit of refactoring ALL THE TIME had me
removing the `console.log` calls. Back to it!

#### 19:26

I have collisions working! Going to go have some dinner and relax a little. This
night is far from over!

#### 20:29

Back from dinner and chores with a hot cup of tea 😊. I was thinking more about
the shifting mechanic in the shower. Originally the shift mechanic would happen
by driving over a 'shift' plate but now I'm thinking it's a could be a key
press...

Going to get the levels changing first then try them both out.

#### 21:02

Was investigating groups in Phaser to solve object ordering issue and discovered
you can iterate group objects. Juist refactored the shit out of my moveObjects
method, yeah!

Ohhh, I also implemented a proper death screen instead of just restarting the
state.

#### 21:51

Oh no, I did it again. Spent way too long in PS when I should be coding 🙄 Going
to finish the night off on the shifter code. Hopefully I can get it done so in
the morning I can concentrate on getting some sounds made.

#### 22:14

Calling it a night, I'm exhusted 😴 I still haven't got the shift mechanic
working but that's ok. I have a decent idea on how to implement it but it will
take some refactoring.