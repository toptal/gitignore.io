Dust helpers unit-tests
------------------------
helpers tests run on node, use the following command

     node test/server.js

Dust-helpers unit-tests using jasmine
-----------------------------

In the current distribution of dust, we have unit tests in jasmine for both the client and the nodejs version.
If you want to run the client version just open the html page called specRunner.html located in
 
     test/jasmine-test/client/specRunner.html

Pre-requisites for tests on node server version: 
----------------------------------
* install nodejs 0.6 or greater
* install npm
* install testing dependencies by running in the package directory:

         npm install

In order to run the node.js version of dust, run this command in the terminal

     node test/jasmine-test/server/specRunner.js


Run tests with make
-------------------
  * core unit tests: 
       make test

  * jasmine unit test
       make jasmine

Note: the above commands has to be run in the project root folder.

Code coverage report
-----------------------------

We are using a tool called node-cover, it can be installed by npm with the following command:

     npm install cover -g

Once you have installed cover, you can use it to generate the code coverage results

Run Cover
-------------- 

      cover run test/jasmine-test/server/specRunner.js // runs all the test and creates a folder with results.
   
      cover report // shows you a table with % code covered, missed lines, #lines, %blocks, missed blocks and # blocks.

      cover report html //creates a folder the location where you run the command and the report is in html.

Cover creates one html file per js file used by the test. The lines that are not covered are shown on red.


