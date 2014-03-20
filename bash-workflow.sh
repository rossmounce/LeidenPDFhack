mkdir phytotaxa
cd phytotaxa/
wget http://www.mapress.com/phytotaxa/content.htm
grep 'content\/' content.htm | tr "\"" "\n" | grep 'content\/' | sort -u | grep -v '\.pdf' | sed 's/content/http:\/\/www\.mapress\.com\/phytotaxa\/content/' > subpages_to_download.txt
wget -w 5 -i subpages_to_download.txt
# rename content page so it doesnt get searched by the next grep
mv content.htm content.old
# parse pdf links, unique sort, free access only, not abstracts, add URL front
## how to put the correct YEAR into the URL string? 2009-2012 will not work
grep '\.pdf' *[0-9].htm | tr "\"" "\n" | grep '\.pdf' | sort -u | grep '^f\/' | grep -v 'f\.pdf' | sed 's/^f\//http:\/\/www\.mapress\.com\/phytotaxa\/content\/2013\/f\//' > free_access_fulltext_pdfs.txt
##2014 or newer has issues in1 brackets (1).htm
grep '\.pdf' *\).htm | tr "\"" "\n" | grep '\.pdf' | sort -u | grep '^f\/' | grep -v 'f\.pdf' | sed 's/^f\//http:\/\/www\.mapress\.com\/phytotaxa\/content\/2014\/f\//' >> free_access_fulltext_pdfs.txt
mkdir free_access_pdfs
cd free_access_pdfs/
wget -w 5 -i ../free_access_fulltext_pdfs.txt
###bash loop
#for f in *.pdf
#	do
#	echo "converting $f"
#	STEM=$(echo $f | awk -F. '{ print $f }')
#	mkdir converted_${STEM%%.*}
#	pdftotext "$f"
#       pdfimages -j "$f" ${STEM%%.*}
#	find . -maxdepth 1 -type f -size -23k -regex ".*\(ppm\|jpg\|pbm\)$" -exec rm -rf {} \;
#	find . -maxdepth 1 -type f -name '*.txt' -exec mv "{}"  ./converted_${STEM%%.*} \; 
#	find . -maxdepth 1 -type f -name '*.jpg' -exec mv "{}"  ./converted_${STEM%%.*} \;
#	find . -maxdepth 1 -type f -name '*.ppm' -exec mv "{}"  ./converted_${STEM%%.*} \;
#	find . -maxdepth 1 -type f -name '*.pbm' -exec mv "{}"  ./converted_${STEM%%.*} \;    
#	done

