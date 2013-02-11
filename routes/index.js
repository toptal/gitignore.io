
/*
 * GET home page.
 */

exports.index = function(req, res){
  res.render('index', { title: 'Express' });
};

/*
 * GET API page.
 */

exports.api = function(req, res){

  res.send(req.params.ignore);
};
