/* 	 Read further only if you analyse cells when doing Anisotropy Experiments!
//   Please load the correct background and Gfactor images. Load also the 'to be'
//   analyzed stacks and rename them PA and PE respectively. These stacks will be
//   background and Gfactor corrected. Each of the stacks will be time-registered
//   (frame alligned, StackReg translation only) and next the PA and PE stacks will 
//   be alligned with respect to each other (MultiStackReg, Affine translation/Load
//   a specific transform). Finally the total intensity and anisotropy will be 
//   calculated.
//   Dont forget to rename the place for saving.
Code Credits: Amit Cherian (NCBS-2018), Thomas Van Zanten (NCBS 2018)
*/   
close("*");//closes all open images
isstack=getBoolean("Do you have a stack of images?");//returns 0 if the user selects "NO"
//load a folder of images and converts to stack     
      if(isstack == 0){
FolderListdir = getDirectory("Choose image Directory ");
         if (File.isDirectory(FolderListdir)) {
         	list = getFileList(FolderListdir);
         	Array.sort(list);}
     for (i=0; i<list.length; i++) {
     	//print((count++) + ": " + FolderListdir + list[i]);
      folder=substring(list[i], 0, lengthOf(list[i])-1);
      dir=FolderListdir+folder+"\\Pos0\\";
      print(dir); 
      
      if(File.exists(dir)==1){
      	open(dir);
      	setSlice(1);
		setMetadata("Label", folder+"_PA");
		setSlice(2);
		setMetadata("Label", folder+"_PE");
      	run("Stack to Images");
      }
      }
    run("Images to Stack", "name=PE-Stack title=PE use");
	run("Images to Stack", "name=PA-Stack title=PA use");
	if(getBoolean("Do you want to save PA and PE stack images?")==1){;
	selectWindow("PE-Stack");
	saveAs("Tiff", FolderListdir+"/PE-Stack");
	selectWindow("PA-Stack");
	saveAs("Tiff", FolderListdir+"/PA-Stack");
	}
    }//Stack pooling done
    
if(isstack == 1){
	waitForUser("Stack has to be named PA-Stack and PE-Stack");
	FolderListdir=getDirectory("Choose a Directory of stack folder");
	if(File.exists(FolderListdir)==1){
      	open(FolderListdir+"\\PA-Stack.tif");
      	open(FolderListdir+"\\PE-Stack.tif");
      	selectWindow("PA-Stack.tif");
      	rename("PA-Stack");
      	selectWindow("PE-Stack.tif");
      	rename("PE-Stack");
	}
}
///Load G-Factor Images         
gfacFolderdir 	= getDirectory("Choose G-Factor Image Directory ");
     	open(gfacFolderdir+"\\Pos0\\");
     	setSlice(1);
		setMetadata("Label", "GF_PA");
		setSlice(2);
		setMetadata("Label", "GF_PE");
		run("Stack to Images");
gfacbgFolderdir = getDirectory("Choose G-Factor Background Image Directory ");
     	open(gfacbgFolderdir+"\\Pos0\\");
     	setSlice(1);
		setMetadata("Label", "GF-BG_PA");
		setSlice(2);
		setMetadata("Label", "GF-BG_PE");
		run("Stack to Images");

imageCalculator("Subtract create 32-bit", "GF_PA","GF-BG_PA");
imageCalculator("Subtract create 32-bit", "GF_PE","GF-BG_PE");
imageCalculator("Divide create 32-bit", "Result of GF_PA","Result of GF_PE");
selectWindow("Result of Result of GF_PA");
rename("Gfactor");

selectWindow("Gfactor");
makeRectangle(158, 158, 192, 194);
run("Measure");
makeRectangle(56, 124, 344, 221);
//setTool("line");
makeLine(75, 67, 434, 434);
run("Plot Profile");
selectWindow("Plot of Gfactor");
rename("G-fac across the field");

if(getBoolean("Continue with the loaded G-Factor?")==1){
	selectWindow("G-fac across the field");close();
	waitForUser("Proceed to background Subtraction");
	
//Open Background Image
	bgFolderdir = getDirectory("Choose Background Image Directory ");
     	open(bgFolderdir+"\\Pos0\\");
     	setSlice(1);
		setMetadata("Label", "BG_PA");
		setSlice(2);
		setMetadata("Label", "BG_PE");
		run("Stack to Images");
imageCalculator("Subtract create 32-bit stack", "PA-Stack","BG_PA");
imageCalculator("Subtract create 32-bit stack", "PE-Stack","BG_PE");
////////////////////////////


selectWindow("Result of PA-Stack");
//If Time lapse, activate next line by de-commenting
//run("StackReg", "transformation=Translation");


////PE*Gfac
imageCalculator("Multiply create 32-bit stack", "Result of PE-Stack","Gfactor");
selectWindow("Result of Result of PE-Stack");
//If Time lapse, activate next line by de-commenting
//run("StackReg", "transformation=Translation");

waitForUser("Proceed to Stack Registration");
selectWindow("BG_PE");close();
selectWindow("BG_PA");close();
selectWindow("GF-BG_PE");close();
selectWindow("GF-BG_PA");close();
selectWindow("GF_PE");close();
selectWindow("GF_PA");close();
selectWindow("PA-Stack");close();
selectWindow("PE-Stack");close();
//Obtain Transform Matrix
if(getBoolean("Do you want to save the Tansform Matrix")==1)
run("MultiStackReg", "stack_1=[Result of PA-Stack] action_1=[Use as Reference] file_1=[] stack_2=[Result of Result of PE-Stack] action_2=[Align to First Stack] file_2=[] transformation=Affine save");
else
run("MultiStackReg", "stack_1=[Result of PA-Stack] action_1=[Use as Reference] file_1=[] stack_2=[Result of Result of PE-Stack] action_2=[Align to First Stack] file_2=[] transformation=Affine");

//If using a custom Transform Matrix, please use this line
//run("MultiStackReg", "stack_1=[Result of PA.tif] action_1=[Use as Reference] file_1=[] stack_2=[Result of Result of PE.tif] action_2=[Load Transformation File] file_2=[] transformation=Affine");

/////PEcorrected*2
selectWindow("Result of Result of PE-Stack");
run("Duplicate...", "title=Double_PE duplicate");
run("Multiply...", "value=2 stack");

//////Numerator
imageCalculator("Subtract create 32-bit stack", "Result of PA-Stack","Result of Result of PE-Stack");
selectWindow("Result of Result of PA-Stack");
rename("top");

////Denomenator
imageCalculator("Add create 32-bit stack", "Result of PA-Stack","Double_PE");
selectWindow("Result of Result of PA-Stack");
rename("total");

imageCalculator("Divide create 32-bit stack", "top","total");
run("Multiply...", "value=1000 stack");
//run("Save", "save=/Users/thomas/Desktop/Pos4corr_An.tif");
rename("anisotropy");
selectWindow("anisotropy");
run("Duplicate...", "title=An_Vis duplicate");

waitForUser("It is recommended that you save your Total and anisotropy Images");
if(getBoolean("Do you want to save Total and Anisotropy images?")==1){
	selectWindow("anisotropy");
	saveAs("Tiff", FolderListdir+"//anisotropy.tif");
	selectWindow("total");
	saveAs("Tiff", FolderListdir+"//total.tif");
}
//run("Save", "save=/Users/thomas/Desktop/Pos4corr_Tot.tif");

selectWindow("An_Vis");
run("physics");
selectWindow("An_Vis");
setMinAndMax(100, 350);
call("ij.ImagePlus.setDefault16bitRange", 16);
run("Gaussian Blur...", "sigma=1 stack");

waitForUser("It might be worth saving the Ani_Vis Images just for quick future references");
if(getBoolean("Do you want to save Ani_Vis images?")==1){
	selectWindow("An_Vis");
	saveAs("Tiff", FolderListdir+"//An_Vis.tif");
}
