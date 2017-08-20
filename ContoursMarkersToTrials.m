function tmarkers = ContoursMarkersToTrials(markers)
%ContoursMarkersToTrials	Rearranges markers into trials
%	TMARKERS = ContoursMarkersToTrials(MARKERS) takes a matrix with 
%	the marker id in the first column and the marker time in the
%	second column. These are the marker ids and their representation:
%		0		Beginning of trial
%		1		Correct response
%		2		Incorrect response
%		3		Time of extinction of fixation spot
%		983040 	Out of target window
%		983041	Entered target window
%		983042	Fixation duration criteria in target window satisfied
%		983043	Left target window after establishing fixation
%		983044	Timed out
%   This function returns TMARKERS which has the follwing format:
%		TMARKERS(i).response
%		TMARKERS(i).num_of_markers
%		TMARKERS(i).markers()
%	where i is the trial number, response is 1 or 0 indicating whether 
%	the response was correct or incorrect, num_of_markers is the number
%	of markers in each trial, and markers contain the actual markers 
%	arranged by rows, with the marker id in column 1 and the marker 
%	time in column 2.

% initialize tmakers in case records is empty
tmarkers = [];

records = size(markers,1);

i = 1;
j = 0;

% last record should be a '255' so we can just parse until the 2nd last
% marker
while i < records,
	switch markers(i,1)
		case {0}
			j = j + 1;		% set to new trial number
			k = 0;

		case {983042}
			k = k + 1;
			tmarkers(j).markers(k,1) = markers(i,1);
			tmarkers(j).markers(k,2) = markers(i,2);		  
			% tmarkers(j).response = 1;
			tmarkers(j).num_of_markers = k;
            tmarkers(j).response = 1;

		case {983044}
			k = k + 1;
			tmarkers(j).markers(k,1) = markers(i,1);
			tmarkers(j).markers(k,2) = markers(i,2);		  
			tmarkers(j).num_of_markers = k;
            tmarkers(j).response = 0;

        otherwise
			k = k + 1;
			tmarkers(j).markers(k,1) = markers(i,1);
			tmarkers(j).markers(k,2) = markers(i,2);		  
	end
	i = i + 1;   
end
