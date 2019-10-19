## Dot Files

These are _my_ dot files. Your mileage may vary.

Environments where these scripts are used: Mac OSX and Linux (Fedora, CentOS, AWS, Ubuntu),
Windows WSL.

I use bash.

I don't use any special extended font sets (e.g. powerline or nerd fonts.) I like the ability
to get the same Command Line eXperience on every Linux (and Mac) machine without root and extra
setup (besides these files.) Also, it's nice to be able to copy and paste from command line to
anywhere.

Some notes:

* On OSX, bash is version 3.  See <https://apple.stackexchange.com/a/197172> for an
  explanation of the lameness. Use brew to update if you want.
* Best terminal program on Mac? Terminal.app. It's sooo fast.
* Light background. I used a dark background for 20 years and it makes you feel c0013r. But
  I noticed something with a light background (solarized-light): I could use a smaller font
  comfortably (SF Mono 10pt on MBP 15). This applies to my editor, vim, as well.

Optional bash command line goodness:

* bash-completion, if you updated to bash v4 on Mac, use bash-completion@2, otherwise v1 works
* autojump

Install:

```
~$ mkdir -p ~/bin
~$ cd ~/bin && git clone https://github.com/brandon133/dotfiles.git
~$ cd ~/bin/dotfiles
~/bin/dotfiles$ ./update [--vim]
```

Set `.bash_profile` to call 

Also, see `install-mac.txt`.
