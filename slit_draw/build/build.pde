// Usage:
//   * press SPACE to save

// set up filename
String filename = "test1";
String fileext = ".jpg";
String foldername = "./";

int max_display_size = 600; // viewing window size (regardless image size)


//chunk array
ArrayList<Chunk> chunks;

PImage buffer;

// image
PImage img;
PImage chunk,slice;
PImage capture;

//trackx,tracky
float mx,my;
int prevX, prevY,firstX,firstY,offsetX,offsetY,prevChunksCount;
boolean firstMove = true;
String dir;

String sessionid;


void settings() {
  img = loadImage(foldername+filename+fileext);

  // calculate window size
  float ratio = (float)img.width/(float)img.height;
  int neww, newh;
  if(ratio < 1.0) {
    neww = (int)(max_display_size * ratio);
    newh = max_display_size;
  } else {
    neww = max_display_size;
    newh = (int)(max_display_size / ratio);
  }
  size(neww,newh,P2D);
}

void setup() {
  sessionid = hex((int)random(0xffff),4);
  textureWrap(REPEAT);
  textureMode(NORMAL);

  noStroke();
  chunks = new ArrayList<Chunk>();

  //create grid
  for(int h = 0; h < height; h++) {
    for(int w = 0; w < width; w++) {
      chunks.add( new Chunk(w,h,1,1,img,0,0) );
    }
  }
  
  // chunks.get(0).draw(false);

}

void draw() {
  for(int chunk = 0; chunk < chunks.size(); chunk++) {
    chunks.get(chunk).draw(false);
  }
  surface.setTitle(int(frameRate) + " fps");
}

void mousePressed() {
  // println("mousedown");
  // println(mouseX + " : " + mouseY);
  prevX = firstX = mouseX;
  prevY = firstY = mouseY;
  firstMove = true;

  capture = get();
  offsetX = 0;
  offsetY = 0;
}


void mouseDragged() {
  offsetX = prevX-mouseX;
  offsetY = prevY-mouseY;


  if(firstMove) {
    if( mouseX != prevX || mouseY != prevY ) {
      
      if(mouseX > prevX){ //move to right
        dir = "RIGHT";
      }
      else if (mouseX < prevX) { //move to left
        dir = "LEFT";
      }

      //move down
      if(mouseY > prevY) {
        dir = "DOWN";
      }
      //move up
      else if (mouseY < prevY) {
        dir = "UP";
      }

      firstMove = false;
    }
  }

  if(dir == "RIGHT") { //move to right
    
    for(int dy = 0; dy < height; dy++) {
      for (int dx = mouseX; dx < width; dx++) {
        int index = (dy*width)+dx;
        chunks.get(index).moveTextureByY(offsetY);
        chunks.get(index).moveTextureByX(offsetX);
      }
    }
  }

  if(dir == "LEFT") { //move to left
    for(int dy = 0; dy < height; dy++) {
      for (int dx = 0; dx < mouseX; dx++) {
        int index = (dy*width)+dx;
        chunks.get(index).moveTextureByY(offsetY);
        chunks.get(index).moveTextureByX(offsetX);
      }
    }
  }

  if(dir == "DOWN") { //move to left

    for(int dy = mouseY; dy < height; dy++) {
      for (int dx = 0; dx < width; dx++) {
        int index = (dy*width)+dx;
        chunks.get(index).moveTextureByY(offsetY);
        chunks.get(index).moveTextureByX(offsetX);
      }
    }
  }

  if(dir == "UP") { //move down
    for(int dy = 0; dy < mouseY; dy++) {
      for (int dx = 0; dx < width; dx++) {
        int index = (dy*width)+dx;
        chunks.get(index).moveTextureByY(offsetY);
        chunks.get(index).moveTextureByX(offsetX);
      }
    }
  }

  // drawAllChunks(prevChunksCount,false);

  prevX = mouseX;
  prevY = mouseY;
}

void mouseReleased() {
}


void drawAllChunks(int start, boolean doTint) {
  
  for(int c = start; c < chunks.size(); c++) {
    chunks.get(c).draw(doTint);
  }
}

void keyPressed() {
  // SPACE to save
  if(keyCode == 32) {
    String fn = foldername + filename + "/res_" + sessionid + hex((int)random(0xffff),4)+"_"+filename+".png";
    buffer = get();
    buffer.save(fn);
    println("Image "+ fn + " saved");
  }

  if(key == 'n') {
    image(img,0,0);
  }

  if(key == 'c') {
    drawAllChunks(0,true);
  }

  if(key == CODED) {
    if (keyCode == ESC) {
      image(img,0,0);
    }
  }
}
