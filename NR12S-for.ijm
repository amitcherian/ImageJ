//This macro lets you batch process a folder of images
//after background sub
//draw and save ROIs
//Measure intensity values
//close all open images
while (nImages>0) { 
          selectImage(nImages); 
          close(); 
      }
//Check imaging parameters
ch=getNumber("How many channels do you have?", 2) ;
chstr=newArray(ch);
for (c=0; c<ch; c++) 	
 	chstr[c]=getString("Name of Channel "+c+1, "");
      
////start batch folder processing 
//open parent folder and list out child folders
FolderListdir = getDirectory("Choose a Directory ");
if (File.isDirectory(FolderListdir))
		 list = getFileList(FolderListdir);
// make sure startup order is consistent
		Array.sort(list);
     for (i=0; i<list.length; i++) {
     	folder=substring(list[i], 0, lengthOf(list[i])-1);
      	dir=FolderListdir+folder+"\\Pos0\\";
		print(dir);
     	for (c=0; c<ch; c++){
     		open(dir+"img_000000000_"+chstr[c]+"_000.tif");
     		rename(folder+"_"+chstr[c]+".tif");
     		}
	}
//Subtract background
	yesbg=getBoolean("Do you have a background image to subtract?");
    if(yesbg==1){
    	for (c=0; c<ch; c++){
    	run("Images to Stack", "name="+chstr[c]+"_Stack.tif title="+chstr[c]+" use");
    
    bgFolderdir = getDirectory("Choose bg Directory ");
	bgdir=bgFolderdir+"\\Pos0\\";
	open(dir+"img_000000000_"+chstr[c]+"_000.tif");
    rename("bg_1_"+chstr[c]+".tif");
    }
	for (c=0; c<ch; c++){
	imageCalculator("Subtract create 32-bit stack", ""+chstr[c]+"_Stack.tif","bg_1_"+chstr[c]+".tif");
	selectWindow("bg_1_"+chstr[c]+".tif");close();
	selectWindow(""+chstr[c]+"_Stack.tif");close();
	}
    }
//Draw ROIs
	ROIdir = getDirectory("Choose a Directory to save ROI List");
	run("ROI Manager...");
	for (i=0; i<list.length; i++) {
     	folder=substring(list[i], 0, lengthOf(list[i])-1);
     	if(folder!="bg_1"){
     		roiManager("Reset");
     		selectWindow(bgresult_blue);
     		roiManager("Show All");
     		selectWindow(bgresult_blue);
     		makeRectangle(10, 10, 15, 15);
     		waitForUser("Draw ROI for "+folder+" and Press OK");
			roiManager("Save", ROIdir+folder+"RoiSet.zip");
			roiManager("Show All");
			roiManager("Multi Measure");
			selectWindow(bgresult_red);
			roiManager("Show All");
			roiManager("multi-measure measure_all one append");
			waitForUser("Copy values from Result Window and Press OK");
			waitForUser("Hope you have Completed copying!");
			selectWindow(bgresult_red);
			roiManager("Show None");
			run("Next Slice [>]");
			selectWindow(bgresult_blue);
     		run("Next Slice [>]");
			}
		}
	
    //filepath=File.openDialog("Select a File");
	//open(filepath); //run("Images to Stack", "name=Stack title=img use");
     
