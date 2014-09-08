'use strict';

var kraken = require('kraken-js'),
    app = require('express')(),
    lusca = require('lusca'),
    session = require('express-session'),
    cookieParser = require('cookie-parser'),
    ua = require('universal-analytics'),
    options = {
        onconfig: function (config, next) {
            //any config setup/overrides here
            next(null, config);
        }
    },
    port = process.env.PORT || 8000;

app.use(ua.middleware(process.env.GA_TRACKING_ID, {cookieName: '_ga'}));
app.use(cookieParser());
app.use(session({secret:'FVCYGYWDWU2B0389FK09', key: 'sid', cookie: {secure: true}}));
app.use(kraken(options));
app.use(lusca({
    csrf: true,
    csp: false,
    xframe: 'SAMEORIGIN',
    p3p: 'JJR38398SJOOSB4YW9WX',
    hsts: {maxAge: 31536000, includeSubDomains: true},
    xssProtection: true
}));

app.listen(port, function (err) {
    console.log('[%s] Listening on http://localhost:%d', app.settings.env, port);
});
