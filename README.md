# P8-Sweeper (entry for Ludum Dare 57)

👉 [Play the game](https://zommerfelds.github.io/ldjam57-p8sweeper/) 👈

todo: screenshot

## Tasks

- [x] Draw base grid with numbers
- [x] Mouse click
- [x] Hide invisible numbers
- [x] Click to uncover
- [x] Flag mines
- [ ] Win and lose condition
- [ ] Make puzzle generation better (solvable)
- [ ] Better graphics like mockup (e.g. don't draw grid in uncovered land)
- [ ] Sound
- [ ] Levels (depth indicator)
- [ ] Exploration animation
- [ ] Story

## Dev notes

To deploy a new version: `bash deploy.sh`

Export zip: first run vscode task, then:

```
"C:\Program Files\7-Zip\7z.exe" a -tzip export/web.zip ./export/index.html ./export/index.js
```

To see debug logs, type "folder" in PICO-8 and open the mylog.txt file.
