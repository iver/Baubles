Baubles - My configuration files
=======

This repository is a result of having gathered many trinkets to configure the terminal, now it contains my own configuration files.

## Content

* [Why](#why)
* [Install](#install)
* [Uninstall](#uninstall)
* [Organization files](#files)
* [Copyright and license](#copy)


### <a name="why"></a> Why

There are a lot of dotfiles, a lot of castles, a little mess… Why don’t we create a one single castle with all of our dotfiles? For some people it can be a reasonable option, but, in general, having them organized has some advantages:

* You can keep different configurations for the same application. A ssh at home and another at work.

* You can keep public the dotfiles you would like to share with the community (vim) and private the ones you don’t want to (mutt).

###  <a name="install"></a> INSTALL

First at all, clone it!

```
git clone https://github.com/iver/Baubles.git ~/Config
```

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

### <a name="files"></a> Organization files

- **bashrc** a setup profile enviroment file for unix-like systems.
- **dotFiles** git and bash scripts directory.
  - **gitconfig** My global git configuration
  - **gitignore_global**  Global git ignore configuration
  - **gitignore_cake**  Git ignore configuration for cakephp projects
  - **ssh_key_add.rb** Load all ssh_key files from ~/.ssh directory on Cygwin shell
- **maintenance** maintenance scripts directory.
  - **dump_databases.sh** Backup each mysql databases into a different file, rather than one big file

## Troubleshooting

***

#### While opening a *.go file.

Message: ``Exuberant ctags not found ``

Fix:

1.  ``` sudo apt-get install exuberant-ctags ```
2.  ``` vim -c ':GoInstallBinaries ```

### <a name="copy"></a> Copyright and license

***

Copyright (c) 2014-2015 Iván Jaimes. See [LICENSE](LICENSE) for details.
