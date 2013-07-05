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
  private Parallax queue[] = new Parallax[50];
  
  private int queue_cnt = 0;
 
  private int canvas_cols;
  private int canvas_rows;
  
  private int play_cnt = 0;
  private int play_pointer = 0;

  ParallaxQueue(int cols, int rows) {
    canvas_cols = cols;
    canvas_rows = rows;
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
    String[] parameters = split(params, "#");
    Parallax parallax = new Parallax(canvas_cols, canvas_rows);
    parallax.addImages(parameters[1]);
    addParallax(parallax, int(parameters[0]));
    
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
      if (testObserver.hasStrips) {   
        queue[play_pointer].draw(registry, testObserver);
      } else if (try_to_simulate) {
        queue[play_pointer].simulate();
      }
      if(++play_cnt >= queue[play_pointer].playtime) {
        play_cnt = 0;
        if (++play_pointer >= queue_cnt) 
          play_pointer = 0;
      }
    }
  }
}


