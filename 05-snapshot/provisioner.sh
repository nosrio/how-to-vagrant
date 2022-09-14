#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

sudo apt-get update
sudo apt-get install python3-pip python3-dev libffi-dev libssl-dev git -y
python3 -m pip install --upgrade pip 
python3 -m pip install --user ansible