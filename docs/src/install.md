## Install

If you just want to install a package from [PyPi](http://pypi.python.org), you
can just issue the following command:

```bash
 % curd install flask
```

After running this command, `flask` and all its dependencies will be retrieved,
built and installed.

## Full usage

```bash
curd install [-r REQUIREMENTS] [-i INDEX] [-c CURDINDEX] [-u] [-f] [PKG [PKG ...]]
```

Where the options are the following

 * **-r REQUIREMENTS**<br>
   Points to a requirements file. The file should contain one package spec per
   line. Pretty much like PIP's `requirements.txt` file To add comments, just
   start them with the hash symbol*(#)*. There's no multi-line comments.

 * **-i INDEX**<br> Specifies a custom Simple PyPi index

 * **-c CURDINDEX**<br> Specifies a custom Simple PyPi index
