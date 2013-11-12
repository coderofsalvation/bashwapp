bashwapp
========

Deadsimple desktop application skeleton using only bash,nc and a webbrowser

### Why is this handy ###

Just use bash and html instead of fiddling with gui toolkits, textmode interfaces, c/c++.
Great for rapid prototyping or interfacing with commandline-stuff.

### Features ###

* based on [bashweb](https://gist.github.com/coderofsalvation/7399049/)
* quickndirty-easy-peasy lightweight httpserver
* direct html-interface to the shell

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
<br><br>
See? It started a miniwebserver, and if you'll see the image below if you surf to http://localhost:8000:

<a href="http://www.zimagez.com/full/cf38438a12e31833329a618ec91320d4ebae2e107ccb25a76924c0fb25bf0a9d2353c0c2c4e1fd0bb0884cd314a350237befbd0767d5372e.php" target="_blank"><img style="width:50%" src="http://www.zimagez.com/full/cf38438a12e31833329a618ec91320d4ebae2e107ccb25a76924c0fb25bf0a9d2353c0c2c4e1fd0bb0884cd314a350237befbd0767d5372e.php"/></a>

### Tips ###

The `app`-bashscript looks for a folder `html`. To get simple web<->bashscript interfacing going on (getargs/forms) run `rm html; cp -R html.skeleton html`.

### Dependancies ###

There are little dependancies, best is to have a linux system, because then the following is already installed in most cases:

* a linux system bash
* nc
* browser

In theory this could also work on windows using cygwin or a standalone bash-binary.

### Credits ###

* bootstrap template from startbootstrap.com
