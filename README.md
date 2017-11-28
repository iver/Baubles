Baubles - My configuration files
=======

This repository is a result of having gathered many trinkets to configure the terminal, now it contains my own configuration files.

## Content

* [Why](#why)
* [Install](#install)
* [Uninstall](#uninstall)
* [Copyright and license](#copy)


### <a name="why"></a> Why

There are a lot of dotfiles, a lot of castles, a little mess… Why don’t we create a one single castle with all of our dotfiles? For some people it can be a reasonable option, but, in general, having them organized has some advantages:

* You can keep different configurations for the same application. A ssh at home and another at work.

* You can keep public the dotfiles you would like to share with the community (vim) and private the ones you don’t want to (mutt).

###  <a name="install"></a> INSTALL

First at all, clone it!

```
git clone https://github.com/iver/Baubles.git ~/Config -b <branch-name>
```

If you are working with Linux, you should clone the linux branch:

```
git clone https://github.com/iver/Baubles.git ~/Config -b linux
```

**Note:** For now I only support linux and mac.

Then, you can run install script.

```
$> chmod +x install.sh
$> ./install.sh
```

But if you prefer uninstall, then.

```
$> chmod +x uninstall.sh
$> ./uninstall.sh
```

Your dot files configuration is ready. So ... enjoy it!

## Troubleshooting

***

#### While opening a *.go file.

Message: ``Exuberant ctags not found ``

Fix:

1.  ``` sudo apt-get install exuberant-ctags ```
2.  ``` vim -c ':GoInstallBinaries ```

on Mac:

1. ```brew install ctags-exuberant```


### <a name="copy"></a> Copyright and license

***

Copyright (c) 2014-2015 Iván Jaimes. See [LICENSE](LICENSE) for details.
