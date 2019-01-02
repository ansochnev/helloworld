#!/bin/bash

DIR=helloworld-1.0.$TRAVIS_BUILD_NUMBER

mkdir -p $DIR/DEBIAN;
mkdir -p $DIR/usr/bin

cp deb/* $DIR/DEBIAN
cp helloworld $DIR/usr/bin
echo "Version: 1.0.$TRAVIS_BUILD_NUMBER" >> $DIR/DEBIAN/control

dpkg -b $DIR

rm -rf $DIR
