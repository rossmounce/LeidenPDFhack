LeidenPDFhack
=============

Extract &amp; release open (CC-BY) biodiversity images from non-PMC biodiversity journals. Starting with Phytotaxa

Inspired by Daniel Mietchen's open access media importer which releases media content from PMC-indexed academic journals.

Starting off with the CC-BY content from Phytotaxa and Zootaxa

1.) **scrape journal links for OA PDF content**

Install Regex-Scraper chrome plugin on:
https://chrome.google.com/webstore/detail/regex-scraper/akjalgjglcdpomokfhgcmononebebioc?hl=en

Go to journal contents page e.g.:
http://www.mapress.com/phytotaxa/content.htm

Regular expression:
content/..../...........

parse out all the OA urls e.g.:
http://www.mapress.com/phytotaxa/content/2014/f/pt00162p216.pdf

'/f/' indicates freely available

compile as link-list and wget all free PDFs


2.) **pdftotext all PDFs to facilitate text-parsing**

check licencing of each:
grep -i 'creative commons' *.txt

for Phytotaxa CC BY licenced 'free' content starts from pt00093p039.pdf onwards

3.) **parse out DOIs of each article and rename PDF by partial doi**

grep -i -m1 '10\.11646\/phytotaxa' *.txt |  tac

Phytotaxa doi's have been implemented starting with http://dx.doi.org/10.11646/phytotaxa.76.1.2
(of the freely accessible PDFs) 

pass each DOI to crossref content negotiation to get full citation for each PDF

4.) **pdfimage strip images out of each article**


5.) **delete 480bytes to 13k (phyotaxa logos from each paper)**

.ppm .pbm .jpg ONLY

6.) **associate figure caption with each image SOMEHOW???**

7.) **Make it all a cronjob to run regularly, re-uploading open, attributed images to Flickr/Wikimedia on a regular basis**
