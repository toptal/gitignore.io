## What's all this here

### Dust in parts
The Dust project consists of 3 parts:

 * **dust.js** - the core (runtime) file responsible for providing:
   * a `dust` namespace
   * all public end user API methods (such as `dust.render`, `dust.makebase`)
   * all publically overridable methods (such as `dust.onError`, `dust.log`) and overridable objects (`dust.helper`)
   * shared utility methods used internally (such as `dust.isArray`)
   * definitions for all internal objects (such as `Context`, `Stub`, `Stream`, etc.)
     * ... which include all internal methods called from the templates (such as `context.get`, `chunk.section`, `chunk.partial`, etc.)
 * **parser.js** - responsible for providing a parse methods which things that look like Dust and turning it into a Dust AST
 * **compiler.js** - responsible for taking Dust AST and turning it into Javscript functions that can be `dust.render`'ed


### server.js
There is one more file in lib: **server.js** (see package.json). This file is the entry point for Node environments.

### dust-core pre-compiling files and keeping a slim runtime
For browser performance, we recommend providing only the **dust-core.js** file to the browser and compiling templates on the server.

You can think of **dust-core.js** as the runtime file. Currently, core only include **dust.js** which provides enough to render basic templates in the browser(without helpers; for templates with helpers see the dustjs-helpers repo).

### dust-full when you need to compile
When you need to compile templates, that is take files written in Dust syntax and converting them to things that can be `dust.render`'ed, you'll need **dust-full.js**.  The **compiler.js** and **parser.js** file are included with **dust.js** in **dust-full.js** in order to provide the compile functionality. 

You should provide **dust-full.js** to the browser if you are compiling templates on demand or if simply just don't want to pre-compile on the server and perf does not matter.

If you are using Node and using `require('dustjs-linkedin')` you are getting dust-full.

### Server vs Browser - the server file
Dust is written to run on both the server and the browser. In truth, it is written to work first on the browser and modified to work on the server. 

A few things are added to make it work on the server:

 * A UMD style wrapper is added to all the files so that, for example, `dust` is returned to `module.exports` in Node whereas it would have returned as `window.dust` in the browser
 * Servers that use npm (Node) need a single main entry point. For us, this is **server.js**  which sets up `dust-full` by pulling in the necessary lib modules, modifies some methods to work in Node, and exports it as a module.
 * Browsers don't need to be a single file but to make it easier a build script is setup so that the necessary lib files are combined into **dist/dust-full.js** and **dist/dust-core.js**.
