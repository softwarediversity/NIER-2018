#!/bin/bash

ROOT_DIR=`pwd`

DONE="config3-83
config3-8
config-38
config3-79
config3-77
config3-73
config3-64
config3-61
config3-57
config3-56
config3-55
config3-54
config3-49
config3-44
config3-32
config3-31
config3-30
config3-3
config3-25
config3-24
config3-23
config3-21
config3-18
config2-92
config2-91
config2-75
config2-68
config2-62
config2-47
config2-42
config2-36
config2-19
config2-15
config-16
config-14
config-1
config0-99
config0-98
config0-93
config0-89
config0-86
config0-78
config0-72
config0-71
config0-58
config0-41
config0-37
config0-35
config0-28
config0-22
config0-20
config0-12
config0-11
config0-10"

for d in `ls gen-dir`
do
	if [ $(echo $DONE | grep $d | wc -l) -eq 0 ];
	then
		cd gen-dir/$d
		mvn clean install
		cd ../..
		./diversify-docker-jvm/gen.sh gen-dir/$d/target/Dockerfile
		echo "docker build -t jhipster-$d gen-dir/$d/target"
		docker build -t jhipster-$d gen-dir/$d/target
	fi
done
