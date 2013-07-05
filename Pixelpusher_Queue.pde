/* Pixelpusher Queue
 * This Processing 2.0 app allows to show simple moving images in multiple layers. It reads the image data 
 * in an array to save time in the scraping process. 
 * Written by @peterkling, powered by @LukeSix
 * 
 * Copyright: Free to use, copy, extend, and whatever you want.
 * 
 * Main Application file
 */

import com.heroicrobot.dropbit.registry.*;
import com.heroicrobot.dropbit.devices.pixelpusher.Pixel;
import com.heroicrobot.dropbit.devices.pixelpusher.Strip;
import java.util.*;

// CONFIG
// #######################################################

// board setting
int canvas_cols = 60; // breite des boards
int canvas_rows = 20; // höhe des boards (wird für bounce modus gebraucht)

// simulate
int simulate_scale = 10;
Boolean try_to_simulate = true;

// OBSERVER
// #######################################################

DeviceRegistry registry;
TestObserver testObserver;


// VARS
// #######################################################

ParallaxQueue queue = new ParallaxQueue(canvas_cols, canvas_rows);


// SETUP
// #######################################################

void setup() {
  registry = new DeviceRegistry();
  testObserver = new TestObserver();
  registry.addObserver(testObserver);
  colorMode(HSB, 360, 100, 100);
  if (try_to_simulate) {
    size(canvas_cols*simulate_scale, canvas_rows*simulate_scale);
  } else {
    size(1,1);
  }
  
  String lines[] = loadStrings("queue.txt");
  for (int i = 0 ; i < lines.length; i++) {
    queue.addParallax(lines[i]);
  }
}

// DRAW
// #######################################################

void draw() {
  queue.draw(registry, testObserver);
}

