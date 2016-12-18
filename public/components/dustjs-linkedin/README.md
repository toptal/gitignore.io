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

### fetch all the node dependencies
```
npm install
```
### Run jshint and tests
```
grunt test
```

## Contributing to Dust

### setup a branch for what you are working on
```
git checkout -b myBranchName
```

### Run jshint and tests
```
grunt test
```

### ... alternatively, run the watcher which hints and tests as you code
```
grunt watch
```

### Add unit tests
Unit tests can be found in the `test/jasmine-tests/spec` directory

### Add an issue and send a pull request
Pull requests are easier to track if you also include an issue
sending a pull request from a branch makes it easier for you to resolve conflicts in master



