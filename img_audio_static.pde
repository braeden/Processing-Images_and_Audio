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
  image = loadImage("data/pluto.png");

  // initialize the audio player
  minim = new Minim(this);
  player = new FilePlayer(minim.loadFileStream("cheetah.wav"));
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
    echoImage();
    echoAudio();
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

// Image Effects
void echoImage() {
  loadPixels();
  for (int col=0; col<width; col++) { // go column by column
    for (int row=0; row<height; row++) { // go through each row
      if (int(random(0, 1000)) == 50) {
        int randPix  = index(int(random(0,height)), int(random(0,width))); //Choose random pixel to color
        int offset = int(random(1,10)); //Glitching offset amount
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

    //pixels[current]  = color(random(0, 255), random(0, 255), random(0, 255))