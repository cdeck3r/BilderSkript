+++
title = "Development IDE - VS code"
description = "Using VS code as the BilderSkripts development IDE"
date = "2020-03-05"
author = "Christian Decker"
sec = 80
+++

<style>
img {
  max-width: 100%;
  height: auto;
}
</style>

We use VS code as the BilderSkript's development IDE. A docker image encapsulates the IDE and makes it accessible through the web browser. An developer's software and programming effort focuses mostly on writing and editing shell scripts. As a consequence, the docker image provides appropriate extensions to support this actitity. 

### Web-based VS code 

Start VS code
```bash
docker-compose up -d vscode
```
and point the web browser to http://localhost:8080.

The vscode container starts with the BilderSkript repo mounted and opened. It stores its state, e.g. last file open, extensions, other settings, in the `vscode` directory within the BilderSkript's project dir.

### Extensions

BilderSkript's vscode docker image and repo comes pre-installed with following extentions especially for working with shell scripts.

* [shfmt](https://github.com/mvdan/sh)
* [shellchecker](https://github.com/koalaman/shellcheck)

The shellchecker runs on-the-fly and provides quick fixes for better coding quality of shell scripts. The shfmt tool reformats the shell script. Use `shift + alt + f` to reformat the script.

### Git

Git version control does not work properly in the current vscode image.