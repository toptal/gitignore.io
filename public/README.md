# gitignore.io

Create useful .gitignore files for your project

[![Build Status](https://travis-ci.org/joeblau/gitignore.io.png?branch=dev-v2)](https://travis-ci.org/joeblau/gitignore.io)
[![GitHub version](https://badge.fury.io/gh/joeblau%2Fgitignore.io.png)](http://badge.fury.io/gh/joeblau%2Fgitignore.io)
[![Dependencies Status](https://david-dm.org/joeblau/gitignore.io.png)](https://david-dm.org/joeblau/gitignore.io)
[![DevDependencies Status](https://david-dm.org/joeblau/gitignore.io/dev-status.png)](https://david-dm.org/joeblau/gitignore.io#info=devDependencies)

# Install Command Line

To run gitignore.io from your command line you need an active internet connection an environment function. You need to add a function to your environment that lets you access the gitignore.io API.

## Git
`#!/bin/bash`
```sh
$ git config --global alias.ignore '!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi'
```

## Linux
`#!/bin/bash`
```sh
$ echo "function gi() { curl -L -s https://www.gitignore.io/api/\$@ ;}" >> ~/.bashrc && source ~/.bashrc
```

`#!/bin/zsh`
```sh
$ echo "function gi() { curl -L -s https://www.gitignore.io/api/\$@ ;}" >> ~/.zshrc && source ~/.zshrc
```

## OSX
`#!/bin/bash`
```sh
$ echo "function gi() { curl -L -s https://www.gitignore.io/api/\$@ ;}" >> ~/.bash_profile && source ~/.bash_profile
```
`#!/bin/zsh`
```sh
$ echo "function gi() { curl -L -s https://www.gitignore.io/api/\$@ ;}" >> ~/.zshrc && source ~/.zshrc
```

## Windows
Create a PowerShell v3 Script
```posh
#For PowerShell v3
Function gi {
  param(
    [Parameter(Mandatory=$true)]
    [string[]]$list
  )
  $params = $list -join ","
  Invoke-WebRequest -Uri "https://www.gitignore.io/api/$params" | select -ExpandProperty content | Out-File -FilePath $(Join-Path -path $pwd -ChildPath ".gitignore") -Encoding ascii
}
```
Create a PowerShell v2 Script
```posh
#For PowerShell v2
Function gi {
  param(
    [Parameter(Mandatory=$true)]
    [string[]]$list
  )
  $params = $list -join ","
  $wc = New-Object System.Net.WebClient
  $wc.Headers["User-Agent"] = "PowerShell/" + $PSVersionTable["PSVersion"].ToString()
  $wc.DownloadFile("https://www.gitignore.io/api/$params", "$PWD\.gitignore")
}
```

Or, if you have curl installed(Generally, [Curl](http://curl.haxx.se/) is bundled with [msysgit](http://msysgit.github.io)), create `curl.cmd` with [this content](https://gist.github.com/912993)
```bat
@rem Do not use "echo off" to not affect any child calls.
@setlocal
 
@rem Get the abolute path to the parent directory, which is assumed to be the
@rem Git installation root.
@for /F "delims=" %%I in ("%~dp0..") do @set git_install_root=%%~fI
@set PATH=%git_install_root%\bin;%git_install_root%\mingw\bin;%PATH%
 
@if not exist "%HOME%" @set HOME=%HOMEDRIVE%%HOMEPATH%
@if not exist "%HOME%" @set HOME=%USERPROFILE%
 
@curl.exe %*
```
And copy it to `C:\Program Files\Git\cmd\curl.cmd`, assuming `msysgit` was installed to `c:\Program Files\Git`.
Then, create `gi.cmd` with this content
```bat
@curl -L -s https://www.gitignore.io/api/%1
```
Copy this `gi.cmd` file to `C:\Program Files\Git\cmd\gi.cmd`, still assuming `msysgit` was installed to `c:\Program Files\Git`.
Make sure that `C:\Program Files\Git\cmd` is added to the environment variable `path`.

# Use Command Line

After the function is created, the `gi` command will give you command line access to the gitingore.io API.

## View
Show output on the command line
```sh
$ gi linux,java
# Created by https://www.gitignore.io

### Linux ###
.*
!.gitignore
*~

### Java ###
*.class
# Package Files #
*.jar
*.war
*.ear
```

## Global
Append Operating System and IDE settings to global .gitignore
```sh
$ gi linux,eclipse >> ~/.gitignore
```

## Project
```sh
$ gi java,python >> .gitignore
```

## List

List displays a list of all of the currently support gitignore.io templates
```sh
$ gi list
actionscript,ada,agda,android,appceleratortitanium,appcode,archives,
archlinuxpackages,autotools,bancha,basercms,bower,bricxcc,c,c++,cakephp,
cfwheels,chefcookbook,clojure,cloud9,cmake,codeigniter,codekit,commonlisp,
compass,composer,concrete5,coq,cvs,dart,darteditor,delphi,django,dotsettings,
dreamweaver,drupal,eagle,eclipse,elasticbeanstalk,elisp,elixir,emacs,ensime,
episerver,erlang,espresso,expressionengine,fancy,finale,flexbuilder,forcedotcom,
freepascal,fuelphp,gcov,go,gradle,grails,gwt,haskell,intellij,java,jboss,jekyll,
jetbrains,joe,joomla,justcode,jython,kate,kdevelop4,kohana,komodoedit,laravel,
latex,lazarus,leiningen,lemonstand,lilypond,linux,lithium,magento,matlab,maven,
mercurial,meteor,modelsim,monodevelop,nanoc,netbeans,node,notepadpp,objective-c,
ocaml,opa,opencart,openfoam,oracleforms,osx,perl,ph7cms,phpstorm,playframework,
plone,prestashop,processing,pycharm,python,qooxdoo,qt,quartus2,r,rails,redcar,
rhodesrhomobile,ros,ruby,rubymine,rubymotion,sass,sbt,scala,scrivener,sdcc,
seamgen,senchatouch,silverstripe,sketchup,stella,sublimetext,sugarcrm,svn,
symfony,symfony2,symphonycms,tags,target3001,tarmainstallmate,tasm,tex,textmate,
textpattern,turbogears2,typo3,unity,vagrant,vim,virtualenv,visualstudio,vvvv,
waf,wakanda,webmethods,webstorm,windows,wordpress,xamarinstudio,xcode,xilinxise,
yeoman,yii,zendframework
```
# About

.gitignore.io is a web service designed to help you create .gitignore files for
your Git repositories. The site has a graphical and command line method of
creating a .gitignore for your operating system, programming language, or IDE.

## License

Copyright (C) 2013-2014 Joe Blau

Permission is hereby granted, free of charge, to any person obtaining a copy of
this software and associated documentation files (the "Software"), to deal in
the Software without restriction, including without limitation the rights to
use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
the Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
