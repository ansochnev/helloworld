#!/bin/bash

DIR=helloworld-1.0.1

mkdir -p $DIR/DEBIAN;
mkdir -p $DIR/usr/bin

cp deb/* $DIR/DEBIAN
cp helloworld $DIR/usr/bin

dpkg -b $DIR

rm -rf $DIR
