cd k/gitea/fg_data
git pull
git add .
timestamp() {
  date +"at %H:%M:%S on %d/%m/%Y"
}
git commit -m "auto-commit $(timestamp)"
git push