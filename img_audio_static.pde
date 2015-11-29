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
  image = loadImage("data/cheetah.jpg");

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
      int current = index(row, col);
      // average the current and echo frame for all channels
      float b = (blue(pixels[current]));
      float r = (red(pixels[current]));
      float g = (green(pixels[current]));
      if (int(random(0, 1000)) == 50) {
        int offset = int(random(1,10));
        for (int i = offset; i<width; i++) {
          int now = index(row, i);
          int back = index(row, i-offset);
          pixels[back] = pixels[now];
          //Import row into arrayList
          //if (i<offset) {
            //for (int j = 1; j<width; j++) {
              
           // }
            //pixels[back] = pixels[now];
           // pixels[now] = color(0,0,255);
         // }
        }
       //pixels[current]  = color(random(0, 255), random(0, 255), random(0, 255));
      } else {
        pixels[current] = color(r, g, b);
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