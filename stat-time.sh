#!/bin/bash

for c in `ls config*`
do
	JU=`cat $c | grep "user" | head -n1`
	MU=`cat $c | grep "user" | tail -n1`
	JS=`cat $c | grep "sys" | head -n1`
	MS=`cat $c | grep "sys" | tail -n1`
	echo "$c | $JU | $MU | $JS | $MS"
done

for c in `ls origin-*`
do
	JU=`cat $c | grep "user" | head -n1`
	MU=`cat $c | grep "user" | tail -n1`
	JS=`cat $c | grep "sys" | head -n1`
	MS=`cat $c | grep "sys" | tail -n1`
	echo "$c | $JU | $MU | $JS | $MS"
done

