#!/bin/bash


ROOT_DIR=`pwd`

function mytime {
	time (eval $1 2> /dev/null) 2>> $ROOT_DIR/$2
}

for f in `ls diversify-jhipster`
do
	DIR=`echo "origin-$f" | cut -d '.' -f1`
	mkdir gen-dir/$DIR
	cp diversify-jhipster/$f gen-dir/$DIR/.yo-rc.json
	cd gen-dir/$DIR
	mytime "yo jhipster" $DIR
	mytime "mvn clean install" $DIR
	cd ../..
done
