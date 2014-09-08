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
```Shell
$ git config --global alias.test '!gi() { curl -s https://www.gitignore.io/api/$@ ;}; gi'
```

## Linux
`#!/bin/bash`
```Shell
$ echo "function gi() { curl -s https://www.gitignore.io/api/\$@ ;}" >> ~/.bashrc && source ~/.bashrc
```

`#!/bin/zsh`
```Shell
$ echo "function gi() { curl -s https://www.gitignore.io/api/\$@ ;}" >> ~/.zshrc && source ~/.zshrc
```

## OSX
`#!/bin/bash`
```Shell
$ echo "function gi() { curl -s https://www.gitignore.io/api/\$@ ;}" >> ~/.bash_profile && source ~/.bash_profile
```
`#!/bin/zsh`
```Shell
$ echo "function gi() { curl -s https://www.gitignore.io/api/${(j:,:)@} ;}" >> ~/.zshrc && source ~/.zshrc
```

## Windows
Create a PowerShell v3 Script
```PowerShell
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
```PowerShell
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

# Use Command Line

After the function is created, the `gi` command will give you command line access to the gitingore.io API.

## View
Show ouput on the command line
```Shell
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
```
$ gi linux,eclipse >> ~/.gitignore
```

## Project
```
$ gi java,python >> .gitignore
```

## List

List displays a list of all of the currently support gitignore.io templates
```
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
