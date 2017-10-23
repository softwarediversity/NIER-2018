#!/bin/bash
TIMEOUT="80"
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
		exit 1
	fi
done

echo $MYTIME
