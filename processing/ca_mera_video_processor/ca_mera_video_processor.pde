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
// implemented in ca-mera / ca-mera+ with a movie file as input.
//
// How to use this sketch:
// 1) set the size according to your movie's pixel dimensions
// 2) set the parameters for the ca-mera algorithm
// 3) run the sketch
//
// if you want to export the frames, uncomment the saveFrame command

import processing.video.*;
import ca_mera.*;

Movie mov;

// ====================
// algorithm parameters
// ====================
int rules[] = {18,18,58};
int srcChan[] = {2,1,0}; // (2 = R, 1 = G, 0 = B)
int thr = 127;
int innothr = 75;
boolean msbFromSrc = true;
// ====================

int inFrame = 0;

void setup() {
  size(514,514); // must correspond to movie pixel dimensions
  mov = new Movie(this, "road.mov"); // change to your own video's filename
  mov.play(); // use .loop() to repeat infinitely
}

void movieEvent(Movie movie) {
  movie.read();
  inFrame++;
}

void draw() {
  if (inFrame>0) {
    mov.loadPixels();
    loadPixels();
    CaMera.process(mov.pixels,pixels,width,height,thr,innothr,rules,srcChan,msbFromSrc);
    updatePixels();
//    saveFrame("frame-"+ inFrame +".png"); // uncomment to export frames
  }
}
