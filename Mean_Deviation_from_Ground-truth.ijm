//Set directory to save results in table to use for analysis
#@ File (style="directory") imageFolder;
dir = File.getDefaultDir;
dir = replace(dir,"\\","/"); 

waitForUser("Ground-truth","Click on the ground-truth image");
rename("Ground-truth");

waitForUser("Prediction","Click on the prediction probability map");
rename("Prediction");

width = getWidth();
height = getHeight();

imageCalculator("Difference create stack", "Ground-truth","Prediction");
bitdepth = bitDepth() 
rename("prediction_prob_ground-truth_diff");

differences = 0
pixels = 0

for (i=0;i<nSlices;i++) {
	for (w=0;w<width;w++) {
		for (h=0;h<height;h++) {
			diff = getValue(w,h)/(pow(2,bitdepth)-1);
			differences += diff;
			pixels += 1;
		}
	}
	run("Next Slice [>]");
}

mean_difference = differences/pixels;
print(mean_difference);

mean_difference_array = newArray();
mean_difference_array = Array.concat(mean_difference_array,mean_difference);

save_option = getBoolean("Want to save results?");
if (save_option == 1){
//Make a table containing the arrays
Table.create("Pixel_Mean_Difference");
Table.setColumn("mean_difference",mean_difference_array);
Table.save(dir+"Pixel_Mean_Difference"+".csv");
}