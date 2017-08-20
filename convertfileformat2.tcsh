#

foreach i (*_eye*)
	set trial = `echo $i | sed -e 's/.*\.//'`
	set nfile = annie04190100_eye.${trial}
	echo "Renaming $i to $nfile"
	mv $i $nfile
end
