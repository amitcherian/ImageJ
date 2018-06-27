
Anisotropy Analysis

1. Analyse cells for Anisotropy_20180620.ijm

This macro helps you analyse images of cells when doing Anisotropy Experiments!
Do have correct background and Gfactor images.
The macro lets you create a stack if you have a folder of cell images.
It also let's you load a stack of cell images, provided PA and PE channels are separate.
If you have a stack, the stacks has to be named PA-Stack and PE-Stack respectively. These stacks will be
background and Gfactor corrected for with the macro. Each of the stacks will be time-registered
(frame alligned, StackReg translation only) and next the PA and PE stacks will 
be alligned with respect to each other (MultiStackReg, Affine translation/Load a specific transform).
Finally the total intensity and anisotropy will be calculated.

2. ROImaker.ijm

This macro helps you draw ROIs, save them, pull the intensity values from the total intenisty image stack and later, apply the same ROI set to the corresponding anisotropy map image pull out the intenisty value.


3. Mask_20180627.ijm

This macro helps you remove anisotropy displayed in the background.

4. Color_Bar-20180627.ijm

This macro helps you generate a color bar (LUT) based on the min and max anisotropy values in the anisotropy map.

5. Montage_20180626.ijm3

This macro helps you put the Anisotropy map and the color bar side by side.

Code Credits: Amit Cherian (NCBS-2018), Thomas Van Zanten (NCBS 2018),
Prof. Satyajit Mayor Lab
National Centre for Biological Sciences,
GKVK Post, Bellary Road
Bangalore 560065
 
