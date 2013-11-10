bashwapp
========

Deadsimple desktop application skeleton using only bash,nc and a webbrowser

### Why is this handy ###

* To have a html/css frontend for bash
* to aid rapid desktop application development.

Instead of fiddling with gui toolkits, textmode interfaces, c/c++, you can just use (this)
bashscript (the best swiss armyknife out there).
It can easily serve htmlfiles to your local browser to interact with bash.

### How does it work ###

Well just run ./app and you'll see something like this:

    $ git clone https://github.com/coderofsalvation/bashwapp.git
    $ cd bashwapp
    $ ./app
    Connection from 127.0.0.1 port 8000 [tcp/*] accepted
    Created new window in existing browser session.
    [Sun Nov 10 17:32:01 CET 2013] out> HTTP/1.1 200 OK
    [Sun Nov 10 17:32:01 CET 2013] out> 
    [Sun Nov 10 17:40:46 CET 2013] in> GET /
    [Sun Nov 10 17:40:46 CET 2013] out> HTTP/1.1 200 OK
    [Sun Nov 10 17:40:46 CET 2013] out> 

See? It started a miniwebserver, and if you'll see the image below if you surf to http://localhost:8000:

<img src="http://www.zimagez.com/full/054f5158d9b0bbef329a618ec91320d4d7a56190231e59806924c0fb25bf0a9d6bd71c1e3111a3cab24808e98069453daba8b15b903973e3.php"/>

### Tips ###

To get simple web<->bashscript interfacing going on (getargs/forms) check [here](http://pastie.org/8470154). Actually you can handle webstuff using any commandline utility you like.

### Dependancies ###

There are little dependancies, best is to have a linux system, because then the following is already installed in most cases:

* a linux system bash
* nc
* browser

In theory this could also work on windows using cygwin or a standalone bash-binary.

### Credits ###

* bootstrap template from startbootstrap.com
