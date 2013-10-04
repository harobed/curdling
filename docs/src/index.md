# Curdling
<small>Curdles your cheesy code and extracts its binaries</small>


Curdling is a tool belt for managing python packages. However, it's a work
in progress. It's currently most notable feature is the ability to install
packages, just like [pip](http://www.pip-installer.org), but much faster.

## Installation

You can use either `pip` or `easy_install` to get curdling installed:

```bash
 % easy_install curdling
```

## Manual

As mentioned before, Curdling is a tool belt for managing packages, each feature
is exposed through a subcommand. Those are the currently available subcommands:

 * **[install](install.md)**
 * **uninstall**<br>
   The support for uninstalling packages is not stable and should only be used
   in disposable environments where you're sure that data loss will not be a
   problem.
