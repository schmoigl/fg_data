#!/usr/bin/env bash
cd /home/lschmoigl/Github/fg_data
git pull
/home/lschmoigl/.pixi/bin/pixi run update
git add .
git commit -m "auto-commit"
git push