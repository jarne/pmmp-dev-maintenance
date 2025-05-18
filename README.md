<h1 align="center">pmmp-dev-maintenance</h1>
<p align="center">Scripts for maintaining a PocketMine-MP dev environment</p>

<p align="center">
    <a href="./LICENSE">
        <img src="https://img.shields.io/github/license/jarne/pmmp-dev-maintenance.svg" alt="License">
    </a>
</p>

## 📙 Description

pmmp-dev-maintenance is an opiniated script for my recurring routines in keeping my [PocketMine-MP](https://github.com/pmmp/PocketMine-MP) installation
for local development up-to-date. It provides several automations to download the latest PHP binaries, PocketMine-MP
release file, sources of the latest release and the [DevTools plugin](https://github.com/pmmp/DevTools).

## 🖥 Usage

Run the script using:

```
./pm-maint.sh
```

Available actions to select from:

| Name | Description |
| --- | --- |
| binaries | Download the latest PHP binary files and symbols |
| server | Download the latest PocketMine-MP release server PHAR and install dependencies |
| pmenv | Replace common files such as the start script, composer lock file, etc., with latest version |
| sources | Download the sources for the latest PocketMine-MP release |
| devtools | Download the latest release of the DevTools plugin |

## ⌨️ Development

The script is created as a simple Bash script. It uses curl for download the files and calling the GitHub API.
Results from the API are parsed using jq.

## 🙋‍ Contribution

Contributions are always very welcome! It's completely equal if you're a beginner or a more experienced developer.

Thanks for your interest 🎉👍!

## 👨‍⚖️ License

[MIT](./LICENSE)
