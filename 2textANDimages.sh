#!/bin/bash
# Usage: attempt to make a plaintext conversion copy of all PDFs in all subfolders (maxdepth 1 folder down) of the working directory

# Turning on the nullglob shell option
shopt -s nullglob

# Loop through pwd cd'ing into each directory then pdftotext all PDFs within each subdirectory
  for f in *.pdf
	do
	echo "started on $f"
	STEM=$(echo $f | awk -F. '{ print $f }')
	echo "pdftotext $f"
	pdftotext "$f"
	echo "pdfimages $f"
        pdfimages -j "$f" ${STEM%%.*}
	echo "find and delete small files $f"
	find . -maxdepth 1 -type f -size -23k -regex ".*\(ppm\|jpg\|pbm\)$" -exec rm -rf {} \;
	echo "move in $f"
	grep 'FIGURE [0-9]' *.txt | sed 's/[^[:alnum:][:punct:][:blank:]]*//g' > captions${STEM%%.*}.out
	grep -i -m1 -h '10\.11646\/phytotaxa' *.txt > doi_${STEM%%.*}.doi
	PARTIAL=$(grep -i -m1 -h '10\.11646\/phytotaxa' *.txt | cut -c 28- )
	mkdir $PARTIAL
	curl -LH "Accept: text/x-bibliography; style=apa" $(cat doi_${STEM%%.*}.doi) > apastring.ref
	cmd="sed -i 's@XYINSERTZ@$(pwd)@' uploadr.ini"
	eval "$cmd"
	cmdtwo="sed -i 's@INSERT_DOI_URL@$(cat *.doi)@' uploadr.ini"
	eval "$cmdtwo"
	cmdthree="sed -i 's@INSERT_APA_REF@$(cat *.ref)@' uploadr.ini"
	eval "$cmdthree"
	#convert ppm's and pbm's to png's & jpg's
	find . -maxdepth 1 -type f -name '*.pbm' | cut -c 3- > needtoconvert.zzz
	find . -maxdepth 1 -type f -name '*.ppm' | cut -c 3- >> needtoconvert.zzz
	for img in $(cat needtoconvert.zzz) 
		do convert $img $img.png
	done
	echo "grep captions out $f"
	rm *.ppm
	rm *.pbm
	find . -maxdepth 1 -type f -name '*.txt' -exec mv "{}"  ./$PARTIAL \; 
	find . -maxdepth 1 -type f -name '*.jpg' -exec mv "{}"  ./$PARTIAL \;
	find . -maxdepth 1 -type f -name '*.png' -exec mv "{}"  ./$PARTIAL \;
	find . -maxdepth 1 -type f -name '*.ref' -exec mv "{}"  ./$PARTIAL \;
	find . -maxdepth 1 -type f -name '*.doi' -exec mv "{}"  ./$PARTIAL \;
	find . -maxdepth 1 -type f -name '*.out' -exec mv "{}"  ./$PARTIAL \;
	python uploadr.py
	cp -f uploadr.ini.bak uploadr.ini
	done
