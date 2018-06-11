// This macro allows you to open a folder of images, 
// Convert it to stack,
// let's you subtract bg if you have one
// else moves on to starting off a template for drawing ROI
// once you are done with an image in the stack, it'll measure the intensity of the drawn ROIs 
// you may choose to copy this data,
// before moving on to the next slice, it saves the ROIs


//close all open images
while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      }
      
//start batch folder processing 
FolderListdir = getDirectory("Choose a Directory ");
if (File.isDirectory(FolderListdir)) {
		 list = getFileList(FolderListdir);
		// make sure startup order is consistent
		Array.sort(list);
     for (i=0; i<list.length; i++) {
     	
		folder=substring(list[i], 0, lengthOf(list[i])-1);
      	dir=FolderListdir+folder+"\\Pos0\\";
		print(dir);
     	if(folder!="bg_1")
     	{	
     		open(dir+"img_000000000_Nr-blue_000.tif");
     		open(dir+"img_000000000_Nr-red_000.tif");
     		     		
			selectWindow("img_000000000_Nr-blue_000.tif");
			rename(folder+"_Nr-blue_000.tif");
			selectWindow("img_000000000_Nr-red_000.tif");
			rename(folder+"_Nr-red_000.tif");
		
     	}
     }
    run("Images to Stack", "name=Nr-blue_Stack title=Nr-blue use");
    run("Images to Stack", "name=Nr-red_Stack title=Nr-red use");
    //Subtract background
    bgFolderdir = getDirectory("Choose bg Directory ");
    //Select the first file of your image sequence
	bgdir=bgFolderdir+"\\Pos0\\";
	run("Image Sequence...", "open=["+bgdir+"img_000000000_Nr-blue_000.tif] sort use");
    run("Stack to Images");
    selectWindow("img_000000000_Nr-blue_000");
	rename("bg_1img_000000000_Nr-blue_000");
	selectWindow("img_000000000_NR-red_000");
	rename("bg_1img_000000000_Nr-red_000");
	imageCalculator("Subtract create 32-bit stack", "Nr-blue_Stack","bg_1img_000000000_Nr-blue_000");
	imageCalculator("Subtract create 32-bit stack", "Nr-red_Stack","bg_1img_000000000_Nr-red_000");		
    selectWindow("bg_1img_000000000_Nr-red_000");close();
	selectWindow("bg_1img_000000000_Nr-blue_000");close();
	selectWindow("Nr-red_Stack");close();
	selectWindow("Nr-blue_Stack");close();
	//Draw ROIs
	
	
	ROIdir = getDirectory("Choose a Directory to save ROI List");
	run("ROI Manager...");
	for (i=0; i<list.length; i++) {
     	folder=substring(list[i], 0, lengthOf(list[i])-1);
     	if(folder!="bg_1"){
     		
     			roiManager("Reset");
     			selectWindow("Result of Nr-blue_Stack");
     			roiManager("Show All");
     			selectWindow("Result of Nr-blue_Stack");
     			makeRectangle(10, 10, 15, 15);
     			waitForUser("Draw ROI for "+folder+" and Press OK");
				roiManager("Save", ROIdir+folder+"RoiSet.zip");
				roiManager("Show All");
				roiManager("Multi Measure");
				selectWindow("Result of Nr-red_Stack");
				roiManager("Show All");
				roiManager("multi-measure measure_all one append");
				waitForUser("Copy values from Result Window and Press OK");
				waitForUser("Hope you have Completed copying!");
				selectWindow("Result of Nr-red_Stack");
				roiManager("Show None");
				run("Next Slice [>]");
				selectWindow("Result of Nr-blue_Stack");
     			run("Next Slice [>]");
	}
	}
	
    //filepath=File.openDialog("Select a File");
	//open(filepath); //run("Images to Stack", "name=Stack title=img use");
     
