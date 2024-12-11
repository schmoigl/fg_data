#!/usr/bin/env bash
echo "Starting"
cd /home/lschmoigl/Github/fg_data

echo "git pull"
git pull

echo "pixi run update"
/home/lschmoigl/.pixi/bin/pixi run update

echo "git"
git add .
git commit -m "auto-commit"
git push