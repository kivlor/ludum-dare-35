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

Fuck me, timers are working! My habit of refactoring ALL THE TIME had me
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
you can iterate group objects. Just refactored the shit out of my moveObjects
method, yeah!

Ohhh, I also implemented a proper death screen instead of just restarting the
state.

#### 21:51

Oh no, I did it again. Spent way too long in PS when I should be coding 🙄 Going
to finish the night off on the shifter code. Hopefully I can get it done so in
the morning I can concentrate on getting some sounds made.

#### 22:14

Calling it a night, I'm exhausted 😴 I still haven't got the shift mechanic
working but that's ok. I have a decent idea on how to implement it but it will
take some refactoring.

Also, pretty sure there's a memory leak. I left the game on the kill screen
while I was freshening up and came back to an almost unresponsive machine 😳 I
might look at that first thing tomorrow then move onto sound.

### 17/04/2105

#### 08:35

Day 2! Starting out by quickly implementing a menu state then I'm going to try
tackle the shift mechanic. Giving myself until 10:00 to get that working and
then I'll move on to adding some sounds 😬

#### 09:00

Spent some time refactoring, adding a menu state and procrastinating on the
shift mechanic...

#### 09:48

10am is looming and I've made very little progress on the shift mechanic, fuck!
pushing my 'switch to sounds' deadline to 11am as the shift mechanic is vital.

Sounds _should_ be easy enough, I basically need:
* running sound
* crash sound
* shift sound

If I get time I'll go back and add a little tune to play in the background as
well.

#### 11:00

Still working on shift mechanic, sooon.

#### 11:43

I've spent the last 40 minutes or so refactoring because I thought my initial
track shift implementation was causing the crash. Turns out there was an infinite
loop happening when trying to determine the next track 😩 The current refactor
_is_ simpler mind you so I'll stick to it.

#### 11:54

I've crashed Chrome so many times in the last hour. I think it's time for a cup
of tea...

#### 12:38

Still struggling with the shift mechanic. I have a super weird bug with the
terrain layers not reset when they should and it's really staring to hurt my. If
I can't work this out by 1pm then I'm going to grab lunch and come back to work
on sounds.

#### 13:10

Shift mechanic done! There are bugs to clean up but that can come after I work
on the sounds. But before any of that I'm going to post a progress update and go
eat some lunch 😋

#### 15:28

Made some super basic sounds in Pico-8. So far I have a running sound and a
crash sound. Going to throw them into the game and get the kill screen
happening after that.

#### 16:06

Bahhh, I've hit a wall. I've spent the last half hour dicking around on the
interwebs. I think I need a proper break away from the screen for a while. I'll
quickly finish what I was working on then go watch some TV.

#### 16:40

Wow, ended up doing a lot more then I thought. The game is in and almost viable
state now. I've created a little todo list in order of priority. Going to
finally take the TV break 😬

#### 18:39

2 and a half hours later... TV break turned into dinner, oh well. Going to get 
the terrain check implemented then start the cleanup.

#### 19:21

The terrain check is working like a treat. It checks 2 things, firstly the the
terrain we're colliding with is the 'upcoming' terrain and that the vehicle is
at least half way into the terrain (although this usually ends up being all the
way in).

I've even started cleaning up!

#### 20:10

Still cleaning up bits and pieces. I added a `gh-pages` branch and pushed that
to github for hosting the final game. I also sent a link to lucas who didn't
seem to mind it.

I really want to create more graphics tonight to finish up. I won't have any
time tomorrow seeing as howe I have work so this is it!

#### 21:03

Haven't quite finished with the cleanup but the only thing left is to fix the
shifter position. It's close but I think there's a bug with the terrain hieghts
so I'm adding some debugging.

#### 21:55

Bless Twinings Assam Bold 🙏 Powering through some new graphics for the air plus
I've updated the sea terrain. Past that all I _really_ need to implement is a
score so there's a sense of accomplishment then I'm done for the night!

#### 22:30

I've gone a bit overbaord with the graphics now 😳 Still need to create an air
obstacle Once that's done I'll implement the per terrain obstacles and finally
a distance counter. But first I'm going to shower to freshen up!

#### 23:25

I AM DONE. There's a few things on the todo list but I'm happy to submit what
I've got. There should still be some time in the morning when I get up if I feel
like adding anything more.

EOF