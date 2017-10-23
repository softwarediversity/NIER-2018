#!/bin/bash


DIR=$1
LOGFILE=`pwd`
FILE=`echo $DIR | rev | cut -d '/' -f1 | rev`
LOGFILE="$LOGFILE/setup-time-$FILE"

function setuptime {
	TIMEOUT="70"
	MYTIME="0"
	curl http://localhost:8080 1> /dev/null 2> /dev/null
	TEST=$?
	while [ $TEST != 0 ]
	do
		sleep 1
		MYTIME=`expr $MYTIME + 1`
		if [ "$MYTIME" -lt "$TIMEOUT" ]
		then
			curl http://localhost:8080 1> /dev/null 2> /dev/null
			TEST=$?
		else
			echo "FAILED TIMEOUT" > $LOGFILE
			exit 1
		fi
	done

	echo $MYTIME > $LOGFILE

}

function wait_node {
	while [ ! -f $LOGFILE ]
	do
	  sleep 1
	done
}

echo "[test-start-up-time] Running on $DIR, log $LOGFILE"

if [ -f $LOGFILE ]
then
	rm $LOGFILE
fi

cd $DIR

./mvnw package -Pprod dockerfile:build

if [ $? -ne 0 ]
then
	echo "FAILED COMPILE" > $LOGFILE
	exit 1
fi

setuptime&

docker-compose -f src/main/docker/app.yml up&
MYPID=$!

wait_node

kill $MYPID

sleep 5
echo "DONE"
