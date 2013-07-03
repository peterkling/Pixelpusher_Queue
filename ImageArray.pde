/* Pixelpusher Queue
 * This Processing 2.0 app allows to show simple moving images in multiple layers. It reads the image data 
 * in an array to save time in the scraping process. 
 * Written by @peterkling, powered by @LukeSix
 * 
 * Copyright: Free to use, copy, extend, and whatever you want.
 * 
 * ImageArray.pde - Reads the image into an array, and stores movement data (offsets)
 */


class ImageArray {
    
  
    // board setting
    int canvas_cols = 60; // breite des boards
    int canvas_rows = 20; // höhe des boards (wird für bounce modus gebraucht)


    // ###########################################################
    // constructor
    // ###########################################################

    ImageArray(String filename, int cols, int rows) {
      canvas_cols = cols;
      canvas_rows = rows;
      paint(filename);
    }
    
    // ###########################################################
    // painting
    // ###########################################################
    
    private int src_cols;
    private int src_rows;
    private int[][] myCanvas;


    // load image
    private void paint(String filename) {
      PImage img = loadImage("images/"+filename);
      src_cols = img.width;
      src_rows = img.height;
      
      
      int build_cols = src_cols;
      int build_rows = src_rows;
      if (src_cols < canvas_cols) 
        build_cols = canvas_cols;
       
      if (src_rows < canvas_rows) 
        build_rows = canvas_rows;
       
      
      myCanvas = new int[build_cols][build_rows];
      
      for (int i = 0; i < src_rows; i++) {
        for (int j = 0; j < src_cols; j++) {
          myCanvas[j][i] = img.get(j, i);
        }
      }
    }
    
    // get pixel
    public color getPaintedPixel(int x, int y) {
      return myCanvas[x][y]; 
    }
    
    // get pixel with offset
    public color getPaintedPixel(int x, int y, int offsetX, int offsetY) {
      int x2;
      offsetX = offsetX % src_cols;
      if (x+offsetX >= src_cols) {
        x2 = x + offsetX - src_cols;
      } else if (x+offsetX < 0) {
        x2 = x + offsetX + src_cols;
      } else {
        x2 = x + offsetX;
      }
      
    
      int y2;
      offsetY = offsetY % src_rows -1;
      if (y+offsetY >= src_rows) {
        y2 = y + offsetY - src_rows;
      } else if (y+offsetY < 0) {
        y2 = y + offsetY + src_rows;
      } else {
        y2 = y + offsetY;
      }
      
      return getPaintedPixel(x2,y2);
    }
    
    // ###########################################################
    // movement
    // ###########################################################

    private float goffsetX = 0;
    private float goffsetY = 0;
    private int gdirectionX = 1;
    private int gdirectionY = 1;
    
    public float moveX = 0.3; // links/rechts bewegen
    public float moveY = 0; // hoch/runter bewegen
    public String moveMode = "bounce"; // endless, bounce

    public void doMove() {
       if (moveMode.equals("bounce")) {
          if (goffsetX+canvas_cols >src_cols || goffsetX < 0) { gdirectionX = gdirectionX*-1; }
          if (goffsetY+canvas_rows >src_rows || goffsetY < 0) { gdirectionY = gdirectionY*-1; }
          goffsetX += moveX*gdirectionX;
          goffsetY += moveY*gdirectionY;
        } else if (moveMode.equals("endless")) {
          goffsetX += moveX;
          goffsetY += moveY;
        }
    }
    
    public color getMovedPixel(int x, int y) {
      //println("getMovedPixel: "+floor(goffsetX)+ " " + floor(goffsetY));
      return getPaintedPixel(x,y,floor(goffsetX),floor(goffsetY));
    }
    
    
    // ###########################################################
    // movement
    // ###########################################################
    
    public void draw(DeviceRegistry registry, TestObserver testObserver, Boolean move) {
  int x=0;
  int y=0;
            
            
  if (testObserver.hasStrips) {   
        registry.startPushing();
        registry.setExtraDelay(0);
        registry.setAutoThrottle(true);    
        List<Strip> strips = registry.getStrips();
        
        int basey= 0;
        int paintX = 0;
        color c;
        if (move)
          this.doMove();
        for (Strip strip: strips) {
          int basex = 0;
          for (int stripx = 0; stripx < strip.getLength(); stripx++) {
            if (floor(stripx/canvas_cols)%2 == 0) {
              x = basex+ floor(stripx % canvas_cols);
            } else {
              x = basex+canvas_cols-1 - floor(stripx % canvas_cols);
            }

            if (stripx % canvas_cols == 0) 
              ++basey;
              
            y = basey;
            if (move) {
              c = this.getMovedPixel(x,y);
            } else {
              c = this.getPaintedPixel(x,y);
            }
            
            strip.setPixel(c, stripx);
          }
        }
  }
}
}
