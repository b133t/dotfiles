## Dot Files

These are _my_ dot files. Your mileage may vary.

Environments where these scripts are used: Mac OSX and Linux (Fedora, CentOS, Ubuntu),
Windows WSL.

Bash forever.

Notes:
* On OSX, default bash is version 3.  See <https://apple.stackexchange.com/a/197172> for
  an explanation of the lameness. Use brew to update to version 5
* Best terminal program on Mac? Terminal.app. It's sooo fast.
* Light background. I used a dark background for 20 years and it makes you feel c0013r.
  But the thing with a light background (solarized-light or PaperColor) is that smaller
  fonts become accessible and are more comfortable (SF Mono 10pt on MBP 15).

Optional bash command line goodness:

* bash-completion, if you updated to bash v5 on Mac, use bash-completion@2, otherwise v1 works
* autojump

Install:

```
~$ mkdir -p ~/bin
~$ cd ~/bin && git clone https://github.com/brandon733/dotfiles.git
~$ cd ~/bin/dotfiles
~/bin/dotfiles$ ./update [--vim]
```

Set `.bash_profile` to call.
