//Hard code the values. This script could be used to find the index of a ROI

function findRoiWithName(roiName) { 
	nR = roiManager("Count"); 
 
	for (i=0; i<nR; i++) { 
		roiManager("Select", i); 
		rName = Roi.getName(); 
		if (matches(rName, roiName)) { 
			return i; 
		} 
	} 
	return 'No such point'; 
} 

print(findRoiWithName('midpoint'));
print(findRoiWithName('perpendicular_line_endpoint'));

//roiManager("Select", findRoiWithName('perpendicular_line_2_endpoint_A')); 
//roiManager("Select", findRoiWithName('perpendicular_line_2_endpoint_B'));

//getSelectionCoordinates(xpoints, ypoints);

//print(xpoints[0]);
//print(ypoints[0]);
