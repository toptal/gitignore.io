<p align="center">
    <a href="https://www.toptal.com/developers/gitignore">
        <img src="Public/img/gitignoreio.svg"/>
    </a>
    <br>
    <strong>Create useful .gitignore files for your project</strong>
</p>
<p align="center">
    <a href="https://swift.org"><img src="https://img.shields.io/badge/Swift-4.1-orange.svg?style=flat-square"/></a>
    <a href="https://travis-ci.org/joeblau/gitignore.io"><img src="https://img.shields.io/travis/joeblau/gitignore.io.svg?style=flat-square" alt="Travis"></a>
    <a href="https://codeclimate.com/github/joeblau/gitignore.io/test_coverage"><img src="https://img.shields.io/codeclimate/coverage/joeblau/gitignore.io.svg?style=flat-square" alt="Code Climate Test Coverage"></a>
    <a href="https://codeclimate.com/github/joeblau/gitignore.io/maintainability"><img src="https://img.shields.io/codeclimate/maintainability/joeblau/gitignore.io.svg?style=flat-square" alt="Code Climate Maintainability"></a>
    <img src="https://img.shields.io/badge/Platforms-Linux%20%7C%20macOS%20%7C%20Windows-blue.svg?style=flat-square"alt="Platforms">
    <a href="https://github.com/joeblau/gitignore.io/blob/master/LICENSE.md"><img src="https://img.shields.io/github/license/joeblau/gitignore.io.svg?style=flat-square" alt="license"></a>
</p>

## About

.gitignore.io is a web service designed to help you create .gitignore files for
your Git repositories. The site has a graphical and command line method of
creating a .gitignore for your operating system, programming language, or IDE.

## `.gitignore` Template Source

Source templates for gitignore.io: https://github.com/toptal/gitignore

## Documentation

Complete gitignore.io documentation: https://docs.gitignore.io/


## Docker Container

### Prerequisites

- [Docker](https://www.docker.com/)

### Build

#### Production
```
$ docker-compose up --build
```

#### Development

```
$ docker-compose -f ./docker-compose-dev.yml build
$ docker-compose -f ./docker-compose-dev.yml up
```
It will start the web server running on [http://localhost:8080](http://localhost:8080)

Development mode mounts the following directories to docker volumes:
- `/Public`
- `/Resources `

## Environment Variables
Please set your environment variables to docker configurations. All are optional.
```
...
services:
  app:
    ...
    environment:
      HOST_ORIGIN: http://www.example.com
      BASE_PREFIX: /foo/bar
      GOOGLE_ANALYTICS_UID:
    ...
...
```
### HOST_ORIGIN
Origin of your web server, falls back to https://www.toptal.com
```
HOST_ORIGIN: http://www.example.com
```

### BASE_PREFIX
If you want to host this web server under a subdirectory (http://www.example.com/foo/bar for example), please set this variable.
```
BASE_PREFIX: /foo/bar
```

### GOOGLE_ANALYTICS_UID
User ID for Google Tag Manager snippet
```
GOOGLE_ANALYTICS_UID: UA-XXXXXXXX-X
```
## E2E Tests

Tests are located in `e2e-tests` folder with:

- API tests in `api` folder - implemented using [Superagent](https://github.com/visionmedia/superagent)
- E2E tests in `pages` folder - implemented with [Puppeteer](https://github.com/puppeteer/puppeteer)

Prerequisites:

- [Node.js](https://nodejs.org/en/) 12.9 or above.
- [Yarn](https://yarnpkg.com/lang/en/) 1.15.2 or 1.17.3

Running:

- Set the BASE_URL env variable (only if you have changed the default URL or port)
- docker-compose up --build --detach
- yarn build
- yarn install
- yarn test
- docker-compose stop
