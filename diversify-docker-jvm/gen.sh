#!/bin/bash

imagesList=diversify-docker-jvm/resources/images

img=`sort -R $imagesList | head -n 1`

#cp resources/Dockerfile ./

sed -i "s/FROM openjdk:8-jre-alpine/FROM $img/g" $1
