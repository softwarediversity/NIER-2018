#!/bin/bash

GEN_DIRECTORY="gen-dir"
DIVERSIFY_SRC_JAR="diversify-collections/target/divcol-1.0-SNAPSHOT-jar-with-dependencies.jar"
N=$1
SUFFIXE=$2

ROOT_DIR=`pwd`


if [ ! -d "$GEN_DIRECTORY" ]; then
	mkdir $GEN_DIRECTORY
fi


function mytime {
	time (eval $1 2> /dev/null) 2>> $NEWTIMELOG
}

for f in `ls diversify-jhipster/* |sort -R |tail -$N`
do
	DIR=`echo "$f" | cut -d '.' -f1 | cut -d '/' -f2`
	echo "-- File $DIR --"
	DIR=$DIR"-"$SUFFIXE
	NEWTIMELOG=$ROOT_DIR/$DIR
	touch $NEWTIMELOG
	echo "-- Trying $DIR --"
	mkdir $GEN_DIRECTORY/$DIR
	cp $f $GEN_DIRECTORY/$DIR/.yo-rc.json
	cd $GEN_DIRECTORY/$DIR

	#Generate
	
	echo "-- Generate $DIR --"
	#time
	#yo jhipster
	printf "JHipster: " >> $NEWTIMELOG
	mytime "yo jhipster"
	cd ../..

	#Sources
	echo "-- Diversify sources for $DIR --"
	#time
	#java -jar $DIVERSIFY_SRC_JAR $GEN_DIRECTORY/$DIR/src/main/java $GEN_DIRECTORY/$DIR/src/main/java $GEN_DIRECTORY/$DIR
	echo "SRC DIV:" >> $NEWTIMELOG
	#mytime "java -jar $DIVERSIFY_SRC_JAR $GEN_DIRECTORY/$DIR/src/main/java $GEN_DIRECTORY/$DIR/src/main/java $GEN_DIRECTORY/$DIR"

	#Build
	echo "-- Diversify dependencies for $DIR --"
	cd diversify-mvn
	#time
	#node compose.js ../$GEN_DIRECTORY/$DIR ../resources/result.json 1
	echo "DEP DIV: " >> $NEWTIMELOG
	mytime "node compose.js ../$GEN_DIRECTORY/$DIR ../resources/result.json 1"
	cd ..
	rm -rf $GEN_DIRECTORY/$DIR
	mv diversify-mvn/$GEN_DIRECTORY/$DIR-0 $GEN_DIRECTORY/$DIR
	
	#Ship
	echo "-- Diversify docker image for $DIR --"
	#time
	./diversify-docker-jvm/gen.sh $GEN_DIRECTORY/$DIR/target/Dockerfile
	
	#time
	#docker build -t jhipster-$DIR $GEN_DIRECTORY/$DIR/target
	
	#Deploy
	echo "-- Deploying $DIR --"
	#docker run -p 44480:8080 jhipster-$DIR

	#Test
	echo "-- Testing $DIR --"
	#echo "Docker Build: $time_docker_build" >> $DIR

done
