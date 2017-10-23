#!/bin/bash

GEN_DIRECTORY="gen-dir"
DIVERSIFY_SRC_JAR="diversify-collections/target/divcol-1.0-SNAPSHOT-jar-with-dependencies.jar"
N=$1
SUFFIXE=$2


if [ ! -d "$GEN_DIRECTORY" ]; then
	mkdir $GEN_DIRECTORY
fi

#for f in `ls diversify-jhipster/* |sort -R |tail -$N`
#do
f=`ls diversify-jhipster/* |sort -R |tail -$N`

DIR=`echo "$f" | cut -d '.' -f1 | cut -d '/' -f2`

echo "-- File $DIR --"

DIR=$DIR"_"$SUFFIXE

NEWTIMELOG=$DIR

touch $NEWTIMELOG

#Generate

echo "-- Generate $DIR --"

printf "hello" > $NEWTIMELOG
