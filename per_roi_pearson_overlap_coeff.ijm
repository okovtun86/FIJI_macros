setOption("BlackBackground", true);
minSize = 0.01; 
maxSize = 1000; 
circularity = 0.3; 

dir = getDirectory("Choose a Directory");

fileList = getFileList(dir);

resultsFilePath = dir + "batch_results.csv";
f = File.open(resultsFilePath);
print(f, "Filename,Object ID,Pearson Overlap Coefficient");

for (i = 0; i < fileList.length; i++) {
    
    if (endsWith(fileList[i], ".tif")) {
        
        open(dir + fileList[i]);
        title = getTitle();
        
        run("Split Channels");

        channel1_title = "C1-" + title;
        channel2_title = "C2-" + title;
        
        selectWindow(channel1_title);
        run("Z Project...", "projection=[Max Intensity]");
        rename("Channel1_MaxIP");

        selectWindow(channel2_title);
        run("Z Project...", "projection=[Max Intensity]");
        rename("Channel2_MaxIP");

        selectWindow("Channel1_MaxIP");
        run("8-bit");
        setAutoThreshold("Otsu dark no-reset");
        run("Analyze Particles...", "size=" + minSize + "-" + maxSize + " circularity=" + circularity + "exclude clear add");
        
        nRois = roiManager("count");
        for (j = 0; j < nRois; j++) {
        	roiManager("Select", j);
        	getSelectionCoordinates(xCoords, yCoords);
        	channel1Pixels=newArray(xCoords.length);
        	channel2Pixels=newArray(xCoords.length);
        	
        	for (p=0;p<xCoords.length;p++){
            	
            	selectWindow("Channel1_MaxIP");
            	channel1Pixels[p] = getPixel(xCoords[p],yCoords[p]);
	            
        		}
        		
        	for (p=0;p<xCoords.length;p++){
        		
        		selectWindow("Channel2_MaxIP");
	            channel2Pixels[p] = getPixel(xCoords[p],yCoords[p]);
        	}
	            
	            sumXY = 0;
	            sumXX = 0;
	            sumYY = 0;
	            
	            for (k = 0; k < channel1Pixels.length; k++) {
	                x = channel1Pixels[k]; 
	                y = channel2Pixels[k]; 
	                sumXY += x * y;
	                sumXX += x * x;
                	sumYY += y * y;
	            }
	            
	            pearsonOverlapCoefficient = sumXY / sqrt(sumXX * sumYY);
	            print(pearsonOverlapCoefficient);
	            print(sumXY);
	            print(sumXX);
	            print(sumYY);
	            
	            print(f, fileList[i] + "," + j + "," + pearsonOverlapCoefficient);
	        }
	
	        run("Close All");
	        roiManager("Reset");
	    }
	}

File.close(f);

print("Batch processing complete. Results saved at: " + resultsFilePath);
