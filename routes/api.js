/*
 * Application API Endpoints
 */
var datastore = require('../datastore');

/*
 * GET CLI Help.
 */
exports.help =  function(req, res){
  res.setHeader('Cache-Control', 'public, max-age=0');
  res.setHeader('Expires', new Date(Date.now()).toUTCString());
  res.send('gitignore.io help:\n  list    - lists the operating systems, programming languages and IDE input types\n  :types: - creates .gitignore files for types of operating systems, programming languages or IDEs\n');
};

/*
 * GET API page.
 */
exports.ignore = function(req, res){
  var ignoreFileList = req.params.ignore.split(",");
  var output = generateFile(ignoreFileList);
  res.setHeader('Cache-Control', 'public, max-age=0');
  res.setHeader('Content-Type', 'text/plain');
  res.setHeader('Expires', new Date(Date.now()).toUTCString());
  res.send(output);
};

/*
 * POST API File
 */
exports.file = function(req, res){
  var ignoreFileList = req.params.ignore.split(',');
  var output = generateFile(ignoreFileList);
  res.setHeader('Cache-Control', 'public, max-age=0');
  res.setHeader('Content-Type', 'application/octet-stream');
  res.setHeader('Expires', new Date(Date.now()).toUTCString());
  res.setHeader('Content-Disposition', 'attachment; filename=".gitignore"');
  res.send(output);
};

/*
 * GET List of all ignore types
 */
exports.listTypes = function(req, res){
  res.setHeader('Cache-Control', 'public, max-age=0');
  res.setHeader('Content-Type', 'text/plain');
  res.setHeader('Expires', new Date(Date.now()).toUTCString());
  res.send(datastore.JSONString);
};

/*
 * Helper for generating concatenated gitignore templates
 */
function generateFile(list){
  var output = "# Created by http://www.gitignore.io\n";
  for (var file in list) {
    if (datastore.JSONObject[list[file]] === undefined){
      output += "\n#!! ERROR: " + list[file] + " is undefined. Use list command to see defined gitignore types !!#\n";
    } else {
      output += "\n### " + datastore.JSONObject[list[file]].name + " ###\n";
      output += datastore.JSONObject[list[file]].contents + "\n";
    }
  }
  return output;
}
