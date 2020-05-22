#!/usr/bin/env bash

# CD to current durectory
cd "$(dirname "$0")" || exit
cd ..

bundle exec rerun --background ./app.rb

