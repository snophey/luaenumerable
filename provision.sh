#!/usr/bin/env bash

sudo apt-get update
sudo apt-get install lua5.1 luarocks -y
luarocks install busted
