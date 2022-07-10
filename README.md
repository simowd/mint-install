# Linux Mint 20.3 files and programs installation

To run the repo you should:

```
chmod +x install-script.sh
chmod +x install-programs.sh
chmod +x install-work.sh
```

And to run the file you should run them indivually:

`sudo CUSTOM_USER=$(whoami) --preserve-env=HOME sh ./install-script.sh`

`sudo CUSTOM_USER=$(whoami) --preserve-env=HOME sh ./install-programs.sh`

`sudo --preserve-env=HOME sh ./install-work.sh`
