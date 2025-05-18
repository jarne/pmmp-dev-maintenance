<h1 align="center">pmmp-dev-maintenance</h1>
<p align="center">Scripts for maintaining a PocketMine-MP dev environment</p>

<p align="center">
    <a href="./LICENSE">
        <img src="https://img.shields.io/github/license/jarne/pmmp-dev-maintenance.svg" alt="License">
    </a>
</p>

## 📙 Description

pmmp-dev-maintenance is an opinionated script for my recurring routines in keeping my [PocketMine-MP](https://github.com/pmmp/PocketMine-MP) installation
for local development up-to-date. It provides several automations to download the latest PHP binaries, PocketMine-MP
release file, the sources of the latest release and the [DevTools plugin](https://github.com/pmmp/DevTools).

The script is developed and tested on Linux (Ubuntu), but it was previously used successfully on macOS, too.

## 🖥 Usage

Edit the file `pm-maint.sh` (settings part at the beginning of the file) depending on your system environment:

| Variable | Description |
| --- | --- |
| `BINARIES_TARGET_ARCH` | System architecture, possible values are `Linux-x86_64`, `MacOS-x86_64`, ... (see files section of [releases of https://github.com/pmmp/PHP-Binaries](https://github.com/pmmp/PHP-Binaries) for a full list) |
| `BINARIES_TAG` | Tag of the latest PHP binaries used by PocketMine-MP, this is `pm5-latest` at the time of writing, also see [releases of https://github.com/pmmp/PHP-Binaries](https://github.com/pmmp/PHP-Binaries) for an up-to-date value (release tag) |

Run the script using:

```
./pm-maint.sh
```

Available actions to select from:

| Name | Description |
| --- | --- |
| binaries | Download the latest PHP binary files and symbols |
| server | Download the latest PocketMine-MP release server PHAR and install dependencies |
| pmenv | Replace common files such as the start script, composer lock file, etc., with the latest version |
| sources | Download the sources for the latest PocketMine-MP release |
| devtools | Download the latest release of the DevTools plugin |

## ⌨️ Development

The script is created as a simple Bash script. It uses curl for download the files and to call the GitHub API.
Results from the API are parsed using jq.

The script file has three parts:

1. Variable declarations for environment, API url's and file names
2. Functions to parse infos about the latest releases from the GitHub API
3. Functions to update specific parts of the installations (actual actions that are executed)

## 🙋‍ Contribution

Contributions are always very welcome! It's completely equal if you're a beginner or a more experienced developer.

Thanks for your interest 🎉👍!

## 👨‍⚖️ License

[MIT](./LICENSE)
