/* This macro is adapted from ROI_Color_Coder.ijm by Tiago Ferreira, v.5.4 2017.03.10
 * IJ BAR: https://github.com/tferr/Scripts#scripts
 * http://imagejdocu.tudor.lu/doku.php?id=macro:roi_color_coder
 *
 * Colorizes ROIs by matching LUT indexes to measurements in the Results table. It is
 * complementary to the ParticleAnalyzer (Analyze>Analyze Particles...), generating
 * particle-size heat maps. Requires IJ 1.47r.
 *
 *Macro edited by Amit Cherian, Prof. Satyajit Mayor Lab, 
 *National Centre for Biological Sciences, Bangalore, India 
 *
 */


setBatchMode(true);
    luts = getList("LUTs");
    lut= "physics";
      selectWindow("Cell");
      getMinAndMax(min, max);
      numLabels= 5;
      decPlaces= 0;
      rampH= 256;
      font= "SanSerif";
      fontS= 12;
      ticks= 1;

// get id of image and number of ROIs to colorize
  // id= getImageID();
  
// make heat-map legend
  rampW= rampH/8; canvasH= 3*fontS+rampH; canvasW= rampH/2; tickL= rampW/4;
  getLocationAndSize(imgx, imgy, imgwidth, imgheight);
  call("ij.gui.ImageWindow.setNextLocation", imgx+imgwidth, imgy);
  newImage("colorbar", "8-bit ramp", rampH, rampW, 1);

// load the LUT as a hexColor array
  roiColors= loadLutColors(lut);

// continue the legend design
  saveSettings;
  setColor(0, 0, 0);
  setBackgroundColor(255, 255, 255);
  setLineWidth(1);
  setFont(font, fontS, "antialiased");
  run("RGB Color");
  if (ticks) { // left & right borders
      drawLine(0, 0, rampH, 0);
      drawLine(0, rampW-1, rampH, rampW-1);
  } else
      drawRect(0, 0, rampH, rampW);
  run("Rotate 90 Degrees Left");
  run("Canvas Size...", "width="+ canvasW +" height="+ canvasH +" position=Center-Left");

// draw ticks and values
  step= rampH;
  if (numLabels>2)
      step /= (numLabels-1);
  for (i=0; i<numLabels; i++) {
      yPos= round(fontS/2 + (rampH - i*step - 1))+fontS;
      rampLabel= min + (max-min)/(numLabels-1) * i;
      drawString( d2s(rampLabel,decPlaces), rampW+2, yPos+fontS/2);
      if (ticks) {
          drawLine(0, yPos, tickL, yPos);               // left tick
          drawLine(rampW-1-tickL, yPos, rampW-1, yPos); // right tick
      }
  }

// parse symbols in unit and draw final label below ramp
  label= "";
  uW= minOf(getStringWidth(label), rampW);
  drawString(label, (rampW-uW)/2, canvasH);
  restoreSettings;

setBatchMode("exit & display");

function loadLutColors(lut) {
  run(lut);
  getLut(reds, greens, blues);
  hexColors= newArray(256);
  for (i=0; i<256; i++) {
      r= toHex(reds[i]); g= toHex(greens[i]); b= toHex(blues[i]);
      hexColors[i]= ""+ pad(r) +""+ pad(g) +""+ pad(b);
  }
  return hexColors;
}
function pad(n) {
  n= toString(n); if (lengthOf(n)==1) n= "0"+n; return n;
}


