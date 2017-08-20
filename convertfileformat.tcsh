#

set myfile = `ls *0001.bin`
set session = `echo $myfile | sed -e 's/_.*//'`
set type = `echo $myfile | sed -e 's/.*_//' | sed -e 's/[0-9]//g' | sed -e 's/\.bin//'`

foreach i (*_*.bin)
	set trial = `echo $i | sed -e 's/.*_//' | sed -e 's/[^0-9]//g'`
	set nfile = ${session}_${type}.${trial}
	echo "Renaming $i to $nfile"
	mv $i $nfile
end
