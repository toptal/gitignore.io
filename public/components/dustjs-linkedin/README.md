Dust  [![Build Status](https://secure.travis-ci.org/linkedin/dustjs.png)](http://travis-ci.org/linkedin/dustjs)
====
This is the LinkedIn fork of Dust.

## Getting Started
A quick tutorial for how to use Dust <https://github.com/linkedin/dustjs/wiki/Dust-Tutorial>

More info <http://linkedin.github.io/dustjs/> and <http://linkedin.github.io/dustjs/#installation>


## More
Read more here: <http://linkedin.github.com/dustjs/>.

For LinkedIn dust-helpers:  <https://github.com/linkedin/dustjs-helpers>.

For LinkedIn secure-filters : <https://github.com/linkedin/dustjs-filters-secure>.


## Building Dust locally
### Grab a copy of the repo
```
cd some_project_directory
git clone https://github.com/linkedin/dustjs.git dustjs
cd dustjs

```

### (Optional) Install Grunt-cli
* Grunt-cli lets you run Grunt from within a subfolder see http://gruntjs.com/getting-started
```
npm install -g grunt-cli
```

### Fetch all node dependencies
```
npm install
```
### Run tests
```
grunt test
```

## Contributing to Dust

* Setup a branch for what you are working on

        git checkout -b myBranchName

* Test your changes (jshint, unit tests in node, rhino and phantom and make sure test coverage thresholds are met)

        grunt test

* Use `grunt dev` while developing\debugging.
This task will start a server and serve Jasmine spec runner on http://localhost:3000/_SpecRunner.html.
This task uses unminified dust-full.js so it allows you to easily step through the code in a browser.

* Use `grunt testClient` to test production version of code (dust-full.min.js) in a browser.
 Similarly to `grunt dev` it serves Jasmine spec runner on `http://localhost:3000/_SpecRunner.html`.

* Add unit tests. Unit tests can be found in the `test/jasmine-tests/spec` directory. Help us keep up good test coverage! To view coverage report run `grunt coverage` and open `tmp/coverage/index.html` in a browser.

* Add an issue and send a pull request. Pull requests are easier to track if you also include an issue. Sending a pull request from a branch makes it easier for you to resolve conflicts in master
