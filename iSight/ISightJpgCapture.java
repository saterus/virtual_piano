/*
Copyright (c) 2005, Ikkjin Ahn 

Permission is hereby granted, free of charge, to any person obtaining a
copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
//package com.ikkjin.matlabtoolbox.isight;

import quicktime.*;
import quicktime.io.*;
import quicktime.std.*;
import quicktime.std.sg.*;
import quicktime.std.movies.*;
import quicktime.std.image.*;
import quicktime.qd.*;
import quicktime.sound.*;

import java.awt.*;
import java.awt.event.*;
import javax.swing.Timer;

import java.io.File;
import javax.imageio.ImageIO;
import java.awt.image.BufferedImage;
import java.awt.image.DataBuffer;
import java.awt.image.WritableRaster;
import quicktime.util.RawEncodedImage;

public class ISightJpgCapture {

    private BufferedImage image;
    private WritableRaster raster;
    private QDGraphics gWorld;
    private SequenceGrabber grabber;
	
    private	int []pixels;
    private	int videoWidth, height;
    private    SGVideoChannel vChannel;

    public ISightJpgCapture(int width, int height) {

        QDRect grabBounds;
	QTFile movFile;
        PixMap pixMap;
    	RawEncodedImage reImg;

	this.height=height;

	try{
       	 QTSession.open();
       	 grabber = new SequenceGrabber();

        grabBounds = new QDRect (width, height);
        gWorld = new QDGraphics (grabBounds);
        grabber.setGWorld (gWorld, null);

        // get vChannel and set its bounds
        vChannel = new SGVideoChannel (grabber);
        vChannel.setBounds (grabBounds);

        vChannel.setUsage (StdQTConstants.seqGrabPreview | StdQTConstants.seqGrabRecord | StdQTConstants.seqGrabPlayDuringRecord);
	vChannel.setFrameRate(0);
	vChannel.setCompressorType(1785750887);
        grabber.prepare(true, true);

        grabber.startPreview();
	movFile = new QTFile(new java.io.File("NoFile"));
        grabber.setDataOutput(movFile, quicktime.std.StdQTConstants.seqGrabDontMakeMovie);
        grabber.setDataOutput(null, quicktime.std.StdQTConstants.seqGrabDontMakeMovie);
        grabber.startRecord();

	//for(int i=0;i<5000; i++){
        grabber.update(null);
        grabber.idleMore();
	//}

	pixMap=grabber.getGWorld().getPixMap();
	reImg=pixMap.getPixelData();
	//System.out.println(grabber.getGWorld().getCPixel(100,100).getRGB());
	videoWidth = width + (reImg.getRowBytes() - width * 4) / 4;
	//System.out.println("VideoWidth "+videoWidth);
	pixels = new int[videoWidth * height];

	//System.out.println((pixels[0] & 0x00ff0000)  + " " + (pixels[0] & 0x0000ff00));
        image = new BufferedImage(
            videoWidth, height, BufferedImage.TYPE_INT_RGB);
            raster = WritableRaster.createPackedRaster(DataBuffer.TYPE_INT, videoWidth, height,
             new int[] { 0x00ff0000, 0x0000ff00, 0x000000ff }, null);
        raster.setDataElements(0, 0, videoWidth, height, pixels);

        //    image.setData(raster);
        // ImageIO.write(image, "jpg", new File("./temp2.jpg"));
	//grabber.stop();

	}catch(Exception e){
		e.printStackTrace();
        	QTSession.close();
	}
     }
   public void dispose(){
        try {
            grabber.stop();
            grabber.release();
            grabber.disposeChannel(vChannel);
            image.flush();
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            QTSession.close();
        }
   }
   public Image captureImage(String fileName) {
	try{
           grabber.idle();
           grabber.update(null);
	   gWorld.getPixMap().getPixelData().copyToArray(0, pixels, 0, pixels.length);
           raster.setDataElements(0, 0, videoWidth, height, pixels);
           image.setData(raster);
           ImageIO.write(image, "jpg", new File(fileName));
           return image;
	}catch(Exception e){
	   e.printStackTrace();
	   return null;
        }
    }

    public static void main (String[] args) {
        ISightJpgCapture iSight= new ISightJpgCapture(1600,1200);
	Image temp;
	for(int i=1;i<10;i++){
		temp=iSight.captureImage(i+".jpg");
	}
	System.exit(0);
    }
}
