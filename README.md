# Metasploit Dradis plugin

Send data to Dradis from the Metasploit console.


# Install

Installation is a 2-step process:

* You have to require the Dradis client bindings in Metasploit's Gemfile
* You have to load the Dradis plugin into the Framework

## Adding the Dradis client library

```
$ cd ~/metasploit-framework/
$ vi Gemfile
```

Add the [dradis-client](https://github.com/dradis/dradis-client) gem:

```ruby
gem 'dradis-client', github: 'dradis/dradis-client'
```

Save, close, and run Bundler to install:

```
$ bundle
```



## Loading the Dradis plugin

```
$ cd ~/
$ git clone https://github.com/dradis/metasploit-dradis.git
$ cd ~/.msf4/plugins/
$ ln -s ~/metasploit-dradis/lib/dradis.rb dradis.rb
$ cd ~/metasploit-framework/
$ ./msfconsole -L
msf > load dradis


      ooo.                     8  o           .oPYo. 8                o
      8  `8.                   8              8    8 8
      8   `8 oPYo. .oPYo. .oPYo8 o8 .oPYo.   o8YooP' 8 o    o .oPYo. o8 odYo.
      8    8 8  `' .oooo8 8    8  8 Yb..      8      8 8    8 8    8  8 8' `8
      8   .P 8     8    8 8    8  8   'Yb.    8      8 8    8 8    8  8 8   8
      8ooo'  8     `YooP8 `YooP'  8 `YooP'    8      8 `YooP' `YooP8  8 8   8
      .....::..:::::.....::.....::..:.....::::..:::::..:.....::....8 :....::..
      ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::ooP'.:::::::::
      ::::::::::::::::::::::::::::::::::::::::::::::::::::::::::...:::::::::::


Dradis v0.1.0 plugin loaded
[*] Successfully loaded plugin: Dradis
```

To autoload the plugin every time:

```
$ cat > ~/.msf4/msfconsole.rc << EOF
db_connect -y config/database.yml
load dradis
EOF
```


# Update

```
msf> exit
$ cd ~/metasploit-dradis/
$ git pull
$ cd ~/metasploit-framework/
$ ./msfconsole -L
```

# Contributing

See [CONTRIBUTING.md](https://github.com/dradis/metasploit-dradis/blob/master/CONTRIBUTING.md)

# License

See [LICENSE](https://github.com/dradis/metasploit-dradis/blob/master/LICENSE)
