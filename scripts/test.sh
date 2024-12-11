#!/usr/bin/env bash
echo "Starting"  >> /home/lschmoigl/test-script.txt
cd /home/lschmoigl/Github/fg_data  >> /home/lschmoigl/test-script.txt

echo "git pull"  >> /home/lschmoigl/test-script.txt
git pull  >> /home/lschmoigl/test-script.txt

echo "pixi run update"  >> /home/lschmoigl/test-script.txt
pixi run update  >> /home/lschmoigl/test-script.txt

echo "git"  >> /home/lschmoigl/test-script.txt
git add .  >> /home/lschmoigl/test-script.txt
git commit -m "auto-commit"  >> /home/lschmoigl/test-script.txt
git push  >> /home/lschmoigl/test-script.txt