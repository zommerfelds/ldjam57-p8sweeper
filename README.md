# P8-Sweeper (entry for Ludum Dare 57)

👉 [Play the game](https://zommerfelds.github.io/ldjam57-p8sweeper/) 👈

todo: screenshot

## Tasks

- [x] Draw base grid with numbers
- [ ] Mouse click
- [ ] Hide invisible numbers
- [ ] Click to uncover
- [ ] Flag mines
- [ ] Make puzzle generation better (solvable)
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
