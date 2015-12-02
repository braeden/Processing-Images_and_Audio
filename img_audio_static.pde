import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

// Global Variables
PImage image;
Minim minim;
FilePlayer player;
Noise pinkN;
AudioOutput out;

int ECHO_FRAMES = 100; // pixels and hundreths of a second

void setup() {
  size(1280, 800);

  // initialize the image
  image = loadImage("data/rocket.jpg");

  // initialize the audio player
  minim = new Minim(this);
  player = new FilePlayer(minim.loadFileStream("spaceoddity.mp3"));
  player.loop();

  // initialize the audio effect
  pinkN = new Noise(1, Noise.Tint.PINK);
  // initialize the audio output
  out = minim.getLineOut();  
  player.patch(out); // patch the player to the output
}

void draw() {  
  image.resize(0, 800); // fit the image to the screen
  image(image, 0, 0); // redraw the image

  if (keyPressed) {
    if (key == '1') {
      glitchImage(10);
      echoAudio();
    } else if (key == '2') {
      pixelateImage(10);
    } else if (key == ESC) {
      exit();
    }
  } else {
    normalAudio();
  }
}

// Audio Effects
boolean echoing = false;
void echoAudio() {
  if (!echoing) { // if sound is not echoing patch in the echo
    player.unpatch(out);
    player.patch(pinkN).patch(out);
    echoing = true;
  }
}

void normalAudio() {
  if (echoing) { // if sound is echoing remove the echo patch
    player.unpatch(out);
    player.unpatch(pinkN);
    player.patch(out);
    echoing = false;
  }
}

// Image Static glitch
void glitchImage(int maxGlitch) {
  loadPixels();
  for (int col=0; col<width; col++) { // go column by column
    for (int row=0; row<height; row++) { // go through each row
      if (int(random(0, 1000)) == 500) {
        int randPix  = index(int(random(0,height)), int(random(0,width))); //Choose random pixel to color
        int offset = int(random(1,maxGlitch)); //Glitching offset amount
        for (int i = offset; i<width; i++) {
          int now = index(row, i);          //  |
          int back = index(row, i-offset);  //  v
          pixels[back] = pixels[now]; //Move pixels towards the left in the row by offset amount
        }
        pixels[randPix] = color(random(0, 255), random(0, 255), random(0, 255)); //Random colored pixesl around the image
      }
    }
  }
  updatePixels();
}
void pixelateImage(int pixSize) {
  loadPixels();
  int square = pixSize; //average pixel square size
  for (int col=0; col<width-square; col+=square) { // go column by column
    for (int row=0; row<height-square; row+=square) { // go through each row
      color[][] pixelArray = new color[square][square];
      for (int across = 0; across<square; across++) { //Read each color into a 2d array of colors
        for (int down = 0; down<square; down++) {
          int now = index(row+across, col+down);
          pixelArray[across][down] = pixels[now];
        }
      }
      color average = averageColors(pixelArray); //Get the average color
      for (int across = 0; across<square; across++) { //Write average color to each pixel
        for (int down = 0; down<square; down++) {
          int now = index(row+across, col+down);
          pixels[now] = average;
        }
      }
    }
  }
  updatePixels();
}

// Image Helpers 
int row(int index) {
  return(index / width);
}

int col(int index) {
  return(index % width);
}

int index(int row, int col) {
  return(row*width + col);
}

color averageColors(color[][] colorArray) {
  int redAvg = 0;
  int greenAvg = 0;
  int blueAvg = 0;
  color finalCol = color(0,0,0);
  for (int across = 0; across<colorArray.length; across++) {
    for (int down = 0; down<colorArray.length; down++) {
      redAvg += red(colorArray[across][down]);
      greenAvg += green(colorArray[across][down]);
      blueAvg += blue(colorArray[across][down]);
    }
  }
  int totalSize = colorArray.length*colorArray.length;
  redAvg = redAvg/(totalSize);
  greenAvg = greenAvg/(totalSize);
  blueAvg = blueAvg/(totalSize);
  finalCol = color(redAvg, greenAvg, blueAvg);
  return(finalCol);
}