# Goto

> Navigate long command lines using a minimalistic char-based decision tree.

![git recall](http://imgur.com/QirIcgE.gif)

## Introduction

`Goto` is a program for jumping between command lines charcters using a simple char-based decision tree.
This is particulary usefull when you have to deal with long command line, or to avoid the frustration caused by latency when you want to move 
your cursor while being on remote system. 

## Installation

Clone this project (or just copy goto.sh content somewhere)

```sh
$ git clone https://github.com/Fakerr/git-recall.git
```
then add the following to your `.bashrc` (or `.profile` on Mac):

```sh
if [[ -s "~/path/to/goto.sh" ]]; then
	source ~/path/to/goto.sh
fi
```
## Usage

##### Key bindings:

- <kbd>Ctrl-k</kbd> : enter goto mode from where you can select the character you want to jump to.
- <kbd>ESC</kbd>    : exit goto mode.

If you want to change the default key to enter goto mode, you can set to `GOTO_KEY` your desired key and then source your `.bashrc` or `.profile`.

## Requirements
- OS: Linux or OSX
- Bash 4.3 or more

## Contribution
Pull requests are welcome, along with any feedback or ideas.

## Prior Art
- [`Vim-easymotion`](https://github.com/easymotion/vim-easymotion)
- [`Avy`](https://github.com/abo-abo/avy)

## License

MIT
