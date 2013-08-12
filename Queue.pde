/* Pixelpusher Queue
 * This Processing 2.0 app allows to show simple moving images in multiple layers. It reads the image data 
 * in an array to save time in the scraping process. 
 * Written by @peterkling, powered by @LukeSix
 * 
 * Copyright: Free to use, copy, extend, and whatever you want.
 * 
 * Queue.pde - Handles the queue of multiple Parallax's 
 */

class ParallaxQueue {
  private Parallax queue[];
  
  private int queue_cnt = 0;
  private String queue_filename = "";
  private int queue_all_cnt = 0;
 
  private int canvas_cols;
  private int canvas_rows;
  
  private int play_cnt = 0;
  private int play_pointer = 0;
  
  private long queueTimestamp = 0;

  ParallaxQueue(int cols, int rows, String filename) {
    canvas_cols = cols;
    canvas_rows = rows;
    queue_filename = filename;
  } 
  
  public void addParallax(Parallax parallax, int playtime) {
    parallax.playtime = playtime;
    queue[queue_cnt] = parallax;
    queue_cnt++;
  }
  
  public void addParallax(String images[], int playtime) {
    Parallax parallax = new Parallax(canvas_cols, canvas_rows);
    parallax.addImages(images);
    addParallax(parallax, playtime);
  }
  public void addParallax(String params) {
    println("ADDING: "+params);
    Parallax parallax = new Parallax(canvas_cols, canvas_rows);

    String[] parameters = split(params, "#");
    if (parameters[0].equals("c")) {
      parallax.addImages(parameters[2]);
    } else if (parameters[0].equals("t")) {
      Random random = new Random();
      int bg_id = 0;
      if (parameters.length > 3) {
        bg_id = int(parameters[3]);
      } else {
        bg_id = random.nextInt(backgrounds.length);
      }
      int font_id = 0;
      if (parameters.length > 4) {
        font_id = int(parameters[4]);
      } else {
        font_id = random.nextInt(fonts.length);
      }
      String[] background = backgrounds[bg_id];
      String font = fonts[font_id];
      parallax.addImage("txt$ "+parameters[2]+" $"+background[1]+"$16$"+font+"$3,0.5,0,endless");
      if (background[0] != "") parallax.addImages(background[0]);  
    }
    addParallax(parallax, int(parameters[1]));
    
  }
  
  public void addParallaxs(String parallaxes) {
    String[] pars = split(parallaxes, "|");
    for (String par: pars) {
      addParallax(par);
    }
  }

  public void draw(DeviceRegistry registry, TestObserver testObserver) {
    //println(queue_cnt+" "+ play_pointer+" "+ play_cnt);
    if (queue_cnt > 0) {
        queue[play_pointer].draw(registry, testObserver);
      if (testObserver.hasStrips) {   
        queue[play_pointer].draw(registry, testObserver);
      } else if (try_to_simulate) {
        queue[play_pointer].simulate();
      }
      if(++play_cnt >= queue[play_pointer].playtime) {
        play_cnt = 0;
        if (++play_pointer >= queue_cnt) {
          play_pointer = 0;
          loadQueue();
        }
      }
    }
  }
  
  private void resetQueue(int size) {
    queue_cnt = 0;
     play_cnt = 0;
     play_pointer = 0;
     queue = new Parallax[size];
  }
  
  public void loadQueue() {
      File queue_file = new File(sketchPath+"/"+queue_filename);
      long newTimestamp = queue_file.lastModified();
      //if ( newTimestamp > queueTimestamp) {
        println("loading new queue");
        queueTimestamp = newTimestamp;
        
        String lines[] = loadStrings(queue_filename);

        resetQueue(lines.length);

        for (int i = 0 ; i < lines.length; i++) {
          addParallax(lines[i]);
        }

      /*} else {
        println("queue file not modified!");
      }*/

  }
}


