cd /home/lschmoigl/Github/fg_data
touch here
git pull
pixi run update
git add .
git commit -m "auto-commit"
git push
touch still-here