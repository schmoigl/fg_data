cd ~/Github/fg_data
git pull
Rscript scripts/script_esi.R
git add .
timestamp() {
  date +"at %H:%M:%S on %d/%m/%Y"
}
git commit -m "auto-commit $(timestamp)"
git push
