FolderListdir = getDirectory("Choose a Directory ");
         list = getFileList(FolderListdir);
     for (i=0; i<list.length; i++) {
     	//print((count++) + ": " + FolderListdir + list[i]);
      folder=substring(list[i], 0, lengthOf(list[i])-1);
          
if (isOpen("ROI Manager")) {selectWindow("ROI Manager");run("Close");}
if (isOpen("Results")) {selectWindow("Results");run("Close");}
if (isOpen("Log")) {selectWindow("Log");run("Close");}

run("Set Measurements...", "mean redirect=None decimal=3");

//File.openDialog ("Choose Input Directory");//Select the first file of your image sequence

dir=FolderListdir+folder+"\\Pos0\\";//File.directory;
print(dir); 
run("Image Sequence...", "open=["+dir+"img_000000000_Evolve1_000.tif] sort use");


roiManager("Open", "//jmlabvault/cherian/General/Ananlysis/MM Macro/ROI set/Single ROI.roi");//Specify the location of your ROI set
selectWindow("Pos0"); 
  c=getNumber("Enter number of Cameras", 2);         
         splitDir=dir+"\Result\\"; 
print(splitDir); 
File.makeDirectory(splitDir);
         if(c==2)
         {getDimensions(width, height, channels, slices, frames);
         f=slices/2; 
         run("Stack to Hyperstack...", "order=xyczt(default) channels="+c+" slices=1 frames="+f+" display=Color");   
         run("Split Channels");
         
         selectWindow("C2-Pos0"); 
         run("Flip Vertically");     
         roiManager("Show All");
         roiManager("Multi Measure");
         saveAs("Results", splitDir + "Evolve2-Pos0-Results.csv");
         close(); 
         
         selectWindow("C1-Pos0"); //Select PA window
          
         
         roiManager("Show All");
         roiManager("Multi Measure");
         saveAs("Results", splitDir+"Evolve1-Pos0-Results.csv");
         } 
else {
	selectWindow("Pos0"); //Select PA window
          
         
         roiManager("Show All");
         roiManager("Multi Measure");
         saveAs("Results", splitDir+"Evolve1-Pos0-Results.csv");
}

         run("Close All"); 
		selectWindow("ROI Manager");run("Close");
		selectWindow("Results");run("Close");
		selectWindow("Log");run("Close");
		Dialog.create("Process Completed!");Dialog.show();
		}