dir = getDirectory("Choose a folder with .nd2 z-stack files");

list = getFileList(dir);
for (i = 0; i < list.length; i++) {
    if (endsWith(list[i], ".nd2")) {
        
        path = dir + list[i];
        run("Bio-Formats Importer", "open=[" + path + "] autoscale color_mode=Default rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
        run("Split Channels");
        selectWindow("C1-" + list[i]);
     	run("Subtract Background...", "rolling=50 stack");
    	run("Median...", "radius=4 stack");
    	setAutoThreshold("Otsu dark");
		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Otsu background=Dark calculate black");
   		run("Connected Components Labeling", "connectivity=6 type=float");
  		run("Label Size Filtering", "operation=Greater_Than size=500");
		setThreshold(1.0000, 1000000000000000000000000000000.0000);
		setOption("BlackBackground", true);
		run("Convert to Mask", "method=Otsu background=Dark black");
 		run("Skeletonize (2D/3D)");
   		run("Analyze Skeleton (2D/3D)", "prune=none display");
      	saveAs("Results", dir + list[i] + "_skeleton_results.csv");
      	      	
      	skel_filename = File.getNameWithoutExtension(list[i]);
      	skel_filename = replace(skel_filename, " ", "");
      	selectImage("C1-" + skel_filename + "-lbl-sizeFilt-labeled-skeletons");
      	saveAs("Tiff", dir + skel_filename + "_skeleton.tif");

     	close("*");
        
    }
}
print("Processing complete for all .nd2 files in the folder.");
