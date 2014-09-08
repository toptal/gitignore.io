'use strict';


var kraken = require('kraken-js'),
    app = require('express')(),
    lusca = require('lusca'),
    options = {
        onconfig: function (config, next) {
            //any config setup/overrides here
            next(null, config);
        }
    },
    port = process.env.PORT || 8000;

// require('newrelic');

app.use(kraken(options));
app.use(lusca({
    csrf: false,
    csp: false,
    xframe: 'SAMEORIGIN',
    p3p: 'JJR38398SJOOSB4YW9WX',
    hsts: {maxAge: 31536000, includeSubDomains: true},
    xssProtection: true
}));

app.listen(port, function (err) {
    console.log('[%s] Listening on http://localhost:%d', app.settings.env, port);
});
