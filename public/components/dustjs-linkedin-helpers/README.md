# Dust Helpers  [![Build Status](https://secure.travis-ci.org/linkedin/dustjs-helpers.png)](http://travis-ci.org/linkedin/dustjs-helpers)
Additional functionality for [dustjs-linkedin](http://linkedin.github.com/dustjs/) package

Read more here : <https://github.com/linkedin/dustjs-helpers>

## Getting Started
A quick tutorial for how to use Dust <https://github.com/linkedin/dustjs/wiki/Dust-Tutorial>

## Contributing
* Open https://github.com/linkedin/dustjs-helpers in a browser and fork it. Then clone your fork:

        git clone https://github.com/<your github account>/dustjs-helpers dustjs-helpers
        cd dustjs-helpers

* Set up a branch for what you are working on

        git checkout -b myBranchName

* Install Grunt-cli, it lets you run `grunt` commands. For more information see <http://gruntjs.com/getting-started>

        npm install -g grunt-cli

* Install node dependencies needed for development in this project

        npm install

* Make your changes on the branch and run jshint\tests to make sure changes are OK

        grunt test

* Commit your changes and push them to github

        git add .
        git commit -m "My changes to dustjs-helpers repo"
        git push origin myBranchName

* Go to github and post a pull request, see <https://help.github.com/articles/creating-a-pull-request>

## Coverage report
Running `grunt test` or `grunt testPhantom` generates coverage report under `tmp/coverage` folder. Open `index.html` file in a browser to view the coverage.