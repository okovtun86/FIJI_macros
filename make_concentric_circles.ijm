rings = 4; 

makeOval(92,299,153,153);

Roi.setName("Zone_1");
roiManager("Add");

for (i = 0; i <rings; i++){
	roiManager("Select", roiManager("Count")-1);
	run("Enlarge...", "enlarge=77 pixel");
	Roi.setName("Zone_" + i+2);
	roiManager("Add");

}
