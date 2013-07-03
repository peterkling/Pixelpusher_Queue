Pixelpusher Queue
=================

This Processing 2.0 app allows to show simple moving images in multiple layers for Pixelpushers. It reads the image data in an array to save time in the scraping process. We had some problems with not so powerfull computers to look for something less ressource hungry.


Easy Explanation:
-----------------
Just set your canvas size in the main file and edit queue.txt. Each line represents a single animation which will be queued. The syntax for each line is as follows:
duration#image1.png,moveX,moveY,moveMode;image2.png,moveX,moveY,moveMode;imageX.png,moveX,moveY,moveMode;

- duration is measured in frames
- images can be png, jpg, gif (not animated) and will be looked for in the images folder
- complete transparent pixels of the first image will be replaced with the ones of the next image, and so on.
- At least on image will be needed. And the image size must be at least the size of your canvas/board.
- moveX and moveY represent the value for movement each frame
- moveMode can be "endless" or "bounce" (just one for both dimensions so far)

examples:
- 500#alpha_nowhere_w.png,0.5,0,bounce;fire.png,0.5,1,endless
- 500#alpha_nowhere.png,0.5,0,endless;rainbow.png,-0.4,0,endless

Note on the canvas:
The canvas is thought of being in a zig-zag order. 


File purposes:
--------------

Pixelpusher_Queue.pde - Main Application
Observer.pde - The pixelpusher observer
ImageArray.pde - Reads the image into an array, and stores movement data (offsets)
Parallax.pde - Allows to stack images on top of the other
Queue.pde - Handles the queue of multiple Parallax's 

queue.txt - File with queue-data, which will be read on setup


Disclaimer:
-----------
This is quite rough code, so expect to find bugs in it. Feel free to use it as you wish. Fork it, make it better, make it greater! A better in code documentation might come later..


Thanks:
-------
Thanks to all of the heroicrobots-forum samples (e.g. zig zag and more)


Copyright:
----------
There is none! Use it, copy it, improve it, make the worst and best out of it.
Written by @peterkling, powered by @LukeSIX

