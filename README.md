# Learning to program before you can read

The foundations of programming can be taught to children before they are able to read and write, by representing every concept they need with a symbol and tasking them to use it.

This is a collection of lua code that helps me to teach programming to my children using turtles in the ComputerCraft Minecraft Mod. I stuck the children's drawings on the numpad keys that are used in `move`; if pressed the turtle will do these actions immediately, and the sticker icon makes clear what the action is.

## First steps

The first step in programming is learning to imagine and then describe what you want done, so practice first moving the turtle around and digging or placing blocks. Next, introduce the loop concept to move the turtle to a far place; typing a number and then pressing an action will do the action that many times. 

## Loops

Use the square brackets to put together multiple actions in such a repetition. For instance, `5[up,forward]` will go up and then forward five times. Explain the need to group these so that the robot knows when you are done instructing. Construct the four walls of a house with a nested loop - put the turtle one block above the ground surface, with some building materials selected, and do `4[10[placeUp,placeDown,back]turn]`.

## TODO

While loops are necessary to define such programs as; `while(block in front)[digUp,up]`. Then we can lead into needing variables; for instance, make the robot build a bridge across a gully `forward,while(no block below)[placeDown,forward,increment-counter]`, and then come back using the counter.

Defining you own functions can be done by allowing you to bind a bracketed expression to a key, which you then subsequently use.

## Limitations

You can't see the program while it is being constructed. A good option would be to draw the program with the child prior to typing it in. To avoid typos, perhaps the parent types the program in. Still, it would be really nice to construct a GUI program that shows the program while it is being typed in, and allows you to edit what has been typed, dragging around items.

# Minecraft Mod Installation

## Install Minecraft 1.12.2

In the Minecraft launcher, click 'Versions', 'Add new version'. You will also need to click play on this version once, to download everything for that version.

## Install Minecraft forge

Download the correct jar file for that version of Minecraft (the Minecraft version is between square brackets). Run it from a terminal with `java -jar [filename]`.

## Install Minecraft forge mods

Download CC:Tweaked for that version of Minecraft, and Plethora. Put these jar files in ~/.minecraft/mods.

## Launch Minecraft forge

The installer for Minecraft forge will have added a version in the Minecraft launcher with 'forge' in the name; choose that one.

# Robot placement

Go into creative mode; if you already had a world and it is in survival, you need to open the menu and select 'Open to LAN' because it has an option there to enable cheats. Then you can press forward slash and issue cheats such as `/gamemode 1` to go into creative mode.

You may also need `/time set day` from time to time if it is too dark in game to see your robot. I strongly advise you to set the game to peaceful, as the emergence of nasty creepiest could have quite an impact on small children and will disrupt the peace of mind necessary to learn new things.

Place an advanced mining turtle, and give yourself a keyboard.

Right-click the turtle and issue `label set [name]` to name the turtle. This appears over his head.

Issue `edit foo`, then press control-enter to save a file; this creates the directory `~/.minecraft/saves/[your_save_name]/computer/0` or whatever number this turtle gets. Open a terminal and replace that directory with a symbolic link to this repository.

```
rm -rf ~/.minecraft/saves/RobotCity/computer/0
ln -s [path]/computercraft-programs/ ~/.minecraft/saves/RobotCity/computer/0
```

Now issue `move`. Pressing the icons on your keypad will now work. To issue commands without covering the screen with this black terminal window, select the keyboard in your hand, bind it to the turtle with cntrl-rightclick, position yourself however you want to view the task at hand, and right-click to make the turtle listen to your keyboard input.

