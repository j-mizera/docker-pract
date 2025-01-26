#!/bin/bash

if [ -z "$1" ] ; then
  echo "Usage: $0 <dir>"
  exit 1
fi

apt-get update
apt-get install debootstrap -y
debootstrap --variant=minbase jammy "$1"