// Copyright (C) 2017-2022 MN Signal Processing / Fritz Menzer
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <https://www.gnu.org/licenses/>.

// How to use:
// Move the mouse cursor horizontally to change the brightness threshold.
// Move the mouse cursor vertically to change the innovation threshold.
// Up and down keys change the cellular automaton rule.
// Set liveVideo to true for live video input (otherwise input is read
// from a bitmap).

import processing.video.*;

boolean liveVideo = false;
Capture video;
PImage img;

int rule = 126;

void setup() {
  size(256, 256);
  if (liveVideo) {
    video = new Capture(this, 256, 256);
    video.start();
  } else {
    img = loadImage("image.jpg");
    img.loadPixels();
  }
}

void draw() {
  int srcPixels[];
  if (liveVideo) {
    if (video.available()) {
      video.read();
      video.loadPixels();
    }
    srcPixels=video.pixels;
  } else {
    srcPixels=img.pixels;
  }
  loadPixels();
  int thr = mouseX;
  int innothr = mouseY;
  
  // input : green channel of srcpixels interpreted as 
  //         grayscale from 0=black to 255 = white
  // output: pixels: processed image, initially 0 or 1, then
  //         mapped to 0xFF000000=black and 0xFFFFFFFF=white

  // set up first line
  for (int j=0; j<width; j++) {
    pixels[j]=green(srcPixels[j])>thr?1:0;
  }
  for (int i=1; i<height; i++) {
    // apply cellular automaton rule
    int p=pixels[(i-1)*width]*3;
    for (int j=0; j<width; j++) {
      p=(p<<1)&7;
      if (j+1<width) {
        p=p+pixels[(i-1)*width+j+1];
      }
      pixels[i*width+j]=((1<<p)&rule)>0?1:0;
    }
    // toggle bits if necessary
    for (int j=0; j<width-1; j++) {
      int idx=i*width+j;
      int inpixel=(int)green(srcPixels[idx]);
      int d=abs((pixels[idx-1]+pixels[idx]+pixels[idx+1])*85-inpixel);
      if (d>innothr) {
        pixels[idx]=inpixel>thr?1:0;
      }
    }
  }
  // restore black/white colors
  for (int i=0; i<width*height; i++) {
    pixels[i]=pixels[i]*0xFFFFFF+0xFF000000;
  }
  updatePixels();
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == UP && rule<255) {
      rule++;
    }
    if (keyCode == DOWN && rule>0) {
      rule--;
    }
    println("Rule = ", rule);
  }
}
