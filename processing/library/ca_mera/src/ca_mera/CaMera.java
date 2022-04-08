/* -*- mode: java; c-basic-offset: 2; indent-tabs-mode: nil -*- */

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
// along with this program. If not, see <https://www.gnu.org/licenses/>.

package ca_mera;

import java.lang.Math;

/**
 * This class contains the basic function for the ca-mera cellular automaton processing
 */
public class CaMera {
  /**
   * Reads input array srcPixels and processes them with 3 elementary cellular automata and
   * outputs the result in dstPixels.
   * Both arrays must be of size width * height.
   * @param srcPixels int[] input pixel array (source)
   * @param dstPixels int[] output pixel array (destination)
   * @param width int width of both arrays in pixels
   * @param height int height of both arrays in pixels
   * @param thr int threshold parameter (0-255)
   * @param innothr int innovation threshold parameter (0-255)
   * @param rules int[] 3 elementary cellular automaton rules
   * @param srcChan int[] 3 source channels ((2 = R, 1 = G, 0 = B))
   * @param msbFromSrc boolean toggle most significant bit based on srcPixels
   */
  static public void process(int[] srcPixels, int[] dstPixels, int width, int height, int thr, int innothr, int[] rules, int[] srcChan, boolean msbFromSrc) {
    // set up first line
    for (int j=0; j<width; j++) {
      dstPixels[j]=(((srcPixels[j]>>(8*srcChan[2]))&0xFF)>thr?0x000001:0)
                  +(((srcPixels[j]>>(8*srcChan[1]))&0xFF)>thr?0x000100:0)
                  +(((srcPixels[j]>>(8*srcChan[0]))&0xFF)>thr?0x010000:0);
    }
    for (int i=1; i<height; i++) {
      // apply cellular automaton rule
      int p=dstPixels[(i-1)*width]*3;
      for (int j=0; j<width; j++) {
        p=(p<<1)&0x070707;
        if (j+1<width) {
          p=p+dstPixels[(i-1)*width+j+1];
        }
        dstPixels[i*width+j]=(((1<<( p     &7))&rules[2])>0?0x000001:0)
                            +(((1<<((p>> 8)&7))&rules[1])>0?0x000100:0)
                            +(((1<<((p>>16)&7))&rules[0])>0?0x010000:0);
      }
      // toggle CA bits if necessary
      for (int j=0; j<width-1; j++) {
        int idx=i*width+j;
        for (int c=0; c<3; c++) {
          int inpixel=(srcPixels[idx]>>(8*srcChan[2-c]))&0xFF;
          int outpixel=(((dstPixels[idx-1]+dstPixels[idx]+dstPixels[idx+1])*85)>>(8*c))&255;
          int d = Math.abs(inpixel-outpixel);
          if (d>innothr) {
            int mask = 0xFFFFFF-(0xFF<<(8*c));
            dstPixels[idx]=(dstPixels[idx]&mask)+(inpixel>thr?(1<<(8*c)):0);
          }
        }
      }
    }
    // restore colors
    for (int i=0; i<width*height; i++) {
      dstPixels[i]=dstPixels[i]*0xFF+0xFF000000;
      // toggle output bits if desired
      if (msbFromSrc) {
        dstPixels[i] = dstPixels[i]&(srcPixels[i]|0xFF7F7F7F);
      }
    }
  }
}
