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

// This sketch processes a batch of bitmaps with the cellular automaton
// image processing as implemented in ca-mera / ca-mera+.
//
// How to use this sketch:
// 1) put the images in your data folder
// 2) change the filename template if necessary
// 2) set the size according to your bitmaps' pixel dimensions
// 3) set the parameters for the ca-mera algorithm
// 4) run the sketch
//
// if you want to export the frames, uncomment the saveFrame command

import ca_mera.*;

PImage img;

// ====================
// algorithm parameters
// ====================
int rules[] = {102,18,126};
int srcChan[] = {2,1,0}; // (2 = R, 1 = G, 0 = B)
int thr = 127;
int innothr = 140;
boolean msbFromSrc = true;
// ====================

int inFrame = 0;

void setup() {
  size(514,514); // must correspond to input bitmap pixel dimensions
}

void draw() {
  String inFilename = "img-" + inFrame + ".jpg"; // change to your own filename template
  File f = new File(dataPath(inFilename));
  if (f.exists()) {
    img = loadImage(inFilename);
    loadPixels();
    CaMera.process(img.pixels,pixels,width,height,thr,innothr,rules,srcChan,msbFromSrc);
    updatePixels();
//    saveFrame("frame-"+ inFrame +".png"); // uncomment to export frames
    inFrame++;
  }
}
