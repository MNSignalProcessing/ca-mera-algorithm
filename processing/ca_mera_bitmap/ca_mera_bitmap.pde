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

// This sketch illustrates the cellular automaton image processing as
// implemented in ca-mera / ca-mera+ with a bitmap as input.
//
// How to use this sketch:
// Move the mouse cursor horizontally to change the brightness threshold.
// Move the mouse cursor vertically to change the innovation threshold.
// Changes cellular automaton rules with the following keys:
//   red : Q/A   green : W/S   blue : E/D
// Go through source channels with these keys: R, G, B
// Toggle MSB from source image with the X key.

import ca_mera.*;

PImage img;

int rules[] = {30,126,58};
int srcChan[] = {2,1,0}; // (2 = R, 1 = G, 0 = B)
boolean msbFromSrc = true;

void setup() {
  size(600,500);
  img = loadImage("largerImage.jpg");
  img.loadPixels();
}

void draw() {
  int thr = mouseX*255/(width-1);
  int innothr = mouseY*255/(height-1);
  
  loadPixels();
  CaMera.process(img.pixels,pixels,width,height,thr,innothr,rules,srcChan,msbFromSrc);
  updatePixels();
}

void keyPressed() {
  if ((key == 'q' || key == 'Q') && rules[0]<255) {
    rules[0]++;
  }
  if ((key == 'a' || key == 'A') && rules[0]>0) {
    rules[0]--;
  }
  if ((key == 'w' || key == 'W') && rules[1]<255) {
    rules[1]++;
  }
  if ((key == 's' || key == 'S') && rules[1]>0) {
    rules[1]--;
  }
  if ((key == 'e' || key == 'E') && rules[2]<255) {
    rules[2]++;
  }
  if ((key == 'd' || key == 'D') && rules[2]>0) {
    rules[2]--;
  }
  if ((key == 'r' || key == 'R')) {
    srcChan[0] = (srcChan[0]+1) % 3;
  }
  if ((key == 'g' || key == 'G')) {
    srcChan[1] = (srcChan[1]+1) % 3;
  }
  if ((key == 'b' || key == 'B')) {
    srcChan[2] = (srcChan[2]+1) % 3;
  }

  if ((key == 'x' || key == 'X')) {
    msbFromSrc = !msbFromSrc;
  }

  println("rules = ", rules[0], ",", rules[1], ",", rules[2], "   srcChan = ", srcChan[0], ",", srcChan[1], ",", srcChan[2], "   msbFromSrc = ", msbFromSrc);
}
