#Takes input of individual .txt files and outputs two .txt files, one for people and one for places, each marked up with `/PERSON` and `/LOCATION` respectively.

#!/bin/sh
#echo "doc,entity,entityType,count" > entities.csv
for file in *.txt
do
############################
#If you're using Windows, delete the # from the start of line 8 and add a # to the start of line 9
############################
#nertext=$(java -mx600m -cp ../stanford-ner-2018-10-16/stanford-ner.jar edu.stanford.nlp.ie.crf.CRFClassifier -loadClassifier ../stanford-ner-2018-10-16/classifiers/english.all.3class.distsim.crf.ser.gz -textFile $file)
nertext=$(../stanford-ner-4.0.0/ner.sh $file)

#echo $nertext | egrep -o "(([[:alnum:]]|\.)+/ORGANIZATION([[:space:]]|$))+" | sed 's/\/ORGANIZATION//g' | sort | uniq -c | awk -v name=${file%%.*} '{printf name ","; for (i = 2; i < NF; i++) printf $i " "; printf $NF; printf "," "organization" ","; printf $1;  print ""}' >> entities.csv
echo $nertext | egrep "(([[:alpha:]]|\.)*/PERSON([[:space:]]|$))+" | sed 's|/ORGANIZATION||g' | sed 's|/LOCATION||g' | sed 's|/O||g' >> people.txt
echo $nertext | egrep "(([[:alnum:]]|\.)*/LOCATION[[:space:]](,[[:space:]])?)+" | sed 's|/ORGANIZATION||g' | sed 's|/PERSON||g' | sed 's|/O||g' >> places.txt
done