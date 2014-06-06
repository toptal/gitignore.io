
# subdomain

> Node.JS Express Subdomain Middleware.

I thought that this was a pretty sweet project [express-subdomain-handler](https://github.com/WilsonPage/express-subdomain-handler) but I wanted it crafted a bit differently for my purposes and the ability to force HTTPS and removal of the unneccessary 'www' prefix. Thanks for the inspiration @WilsonPage

```javascript

var subdomain = require('subdomain');

var express = require('express')
  , app = express.createServer();

app.use(subdomain({ base : 'mydomain.com', removeWWW : true }));

app.get('/subdomain/blog/', function(request, response) {
  response.end('<p>blog.mydomain.com</p>');
});

app.get('/subdomain/api/users/', function(request, response) {
  response.end('<p>api.mydomain.com/users</p>');
});

app.get('/hello', function(request, response) {
  response.end('<p>mydomain.com/hello</p>');
});

app.listen(8000);

```

[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/edwardhotchkiss/subdomain/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

