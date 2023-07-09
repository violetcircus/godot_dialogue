violet's simulacrum conversation facilitator
============================================

preload the signal bus or add 

signal display_dialog(text_key)

to ur project's signal bus and ur basically done.

then just add this to whichever piece of code 
you want to trigger dialogue:

display_dialog.emit(self.name)

it uses the name of the node as the name
displayed for the npc in the window and also
to find the correct dialogue tree in the json file.

you should probably create one for each scene that
will contain dialogue. you don't have to listen to me
though. go nuts

it comes with an example JSON file with one dialogue
tree in it. it's a pretty simple structure to follow
even if the reply system is a little obtuse. basically
if you pick replies[0] it'll move down the tree to the 
child at the 0 position in the next object. this means
it skips a line whenever you have replies, so remember 
that (that's why the key is just "next" for the object 
that's siblings with a replies array in the example json)

i'm sure this could be improved. it's like the second 
mildly good thing i've written in godot and was initially
based on a tutorial i found on youtube. steal it and make it
better and tell me about it if you do. or don't. idc much
or it wouldn't use an MIT license

speaking of the tutorial, shoutout this guy:
https://www.youtube.com/watch?v=Ur9j3c5_of0&pp=ygUaZ29kb3QgZGlhbG9ndWUgc3lzdGVtIGpzb24%3D
