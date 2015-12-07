import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
//import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import processing.sound.*;


// Global Variables
PImage image;
Minim minim;
PinkNoise pinkN;
BitCrush bitCrush;
FilePlayer player;
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
  pinkN = new PinkNoise(this);
  // initialize the audio output
  out = minim.getLineOut();  
  player.patch(out); // patch the player to the output
  println(out.sampleRate());
}

void draw() {  
  image.resize(0, 800); // fit the image to the screen
  image(image, 0, 0); // redraw the image

  if (keyPressed) {
    if (key == '1') {
      glitchImage(10);
      glitching = true;
      glitchAudio();
    } else if (key == '2') {
      pixelateImage(10);
      pixelating = true;
      pixelateAudio();
    } else if (key == ESC) {
      exit();
    }
  } else {
    normalAudio();
    pixelating = false;
    glitching = false;
    playOnce = true;
  }
}

// Audio Effects
boolean glitching = false;
boolean pixelating = false;
boolean playOnce = true;
void glitchAudio() {
  if (glitching) { // if sound is not glitching patch in the echo
    if (playOnce) { //Make sure the sound doesnt continue to play
      pinkN.play();
      pinkN.amp(random(1, 9)/10); //Choose random volume for pinkNoise;
      playOnce = false;
    }

    glitching = true;
  }
}
void pixelateAudio() {
  if (pixelating) { // if sound is not glitching patch in the echo
    if (playOnce) {
       bitCrush = new BitCrush(4, out.sampleRate()); //4 = bit res
       player.patch(bitCrush); //Start Bitcrush
       bitCrush.patch(out);
       pixelating = false;
       playOnce = false;
    }
  }
}

void normalAudio() {
  if (glitching || pixelating) { // if sound is glitching or pixelating remove the patch
    if (pixelating) {
      player.unpatch(bitCrush); //Kill bitcrush
      player.unpatch(out);
      bitCrush.unpatch(out);
      player.patch(out);
    }
    pinkN.stop();
    glitching = false;
    pixelating = false;
  }
}

// Image Static glitch
void glitchImage(int maxGlitch) {
  loadPixels();
  for (int col=0; col<width; col++) { // go column by column
    for (int row=0; row<height; row++) { // go through each row
      if (int(random(0, 1000)) == 500) {
        offsetPixels(row, col, maxGlitch); //Gen rand number and offset row to left
        randomPixel(); //Place a random colored pixel in a random place within the image
      }
    }
  }
  updatePixels();
}
void pixelateImage(int square) {
  loadPixels();
  int toRight = width % square;  // To push pixelation as close to the egde w/o going out of bounds 
  int toBottom = width % square; // ^
  for (int col=0; col<width-toRight; col+=square) { // go column by column
    for (int row=0; row<height-toBottom; row+=square) { // go through each row
      color[][] pixelArray = new color[square][square]; //Declare array of colors
      pixelArray = getColors(row, col, square); //Get all of the colors of a given square in that array
      color average = averageColors(pixelArray); //Average the colors from the array
      putColors(row, col, square, average); //Put the color in all the pixel of the respective square
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


void offsetPixels(int row, int col, int maxGlitch) {
  int offset = int(random(1,maxGlitch)); //Glitching offset amount
  for (int i = offset; i<width; i++) {
    int now = index(row, i);          //  |
    int back = index(row, i-offset);  //  v
    pixels[back] = pixels[now]; //Move pixels towards the left in the row by offset amount
  }
}

void randomPixel() {
  int randPix  = index(int(random(0,height)), int(random(0,width))); //Choose random pixel to color
  pixels[randPix] = color(random(0, 255), random(0, 255), random(0, 255)); //Random colored pixesl around the image
}

//Abtracted fucntions for pixelation of image
color[][] getColors(int row, int col, int square) {
  color[][] pixelArray = new color[square][square];
  for (int across = 0; across<square; across++) { //Read each color into a 2d array of colors
    for (int down = 0; down<square; down++) {
      int now = index(row+across, col+down);
      pixelArray[across][down] = pixels[now];
    }
  }
  return pixelArray;
}

color averageColors(color[][] colorArray) {
  double redAvg = 0;
  double greenAvg = 0;
  double blueAvg = 0;
  for (int across = 0; across<colorArray.length; across++) {
    for (int down = 0; down<colorArray.length; down++) {
      redAvg += Math.pow(red(colorArray[across][down]), 2);
      greenAvg += Math.pow(green(colorArray[across][down]), 2);
      blueAvg += Math.pow(blue(colorArray[across][down]), 2);
    } //Thanks /u/gliph
  }
  int totalSize = colorArray.length*colorArray.length;
  redAvg = Math.sqrt(redAvg/(totalSize));
  greenAvg = Math.sqrt(greenAvg/(totalSize));
  blueAvg = Math.sqrt(blueAvg/(totalSize));
  color finalCol = color((int) redAvg, (int) greenAvg,(int) blueAvg);
  return(finalCol);
}

void putColors(int row, int col, int square, color average) {
  for (int across = 0; across<square; across++) { //Write average color to each pixel
    for (int down = 0; down<square; down++) {
      int now = index(row+across, col+down);
      pixels[now] = average;
    }
  } 
}