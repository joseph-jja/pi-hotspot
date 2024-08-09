const https = require( 'https' ),
    exec = require( "child_process" ).exec,
    fs = require( "fs" );

const express = require( 'express' ),
    bodyParser = require( 'body-parser' ),
    winston = require( 'winston' ),
    { engine } = require( 'express-handlebars' );

let server,
    secureServer,
    args = process.argv,
    app = express(),    
    clientCode,
    options = {},
    clientConfig,
    config;

app.engine( '.hbs', engine( {
    defaultLayout: 'baseLayout',
    extname: '.hbs'
} ) );

app.set( 'view engine', '.hbs' );

// for parsing application/json
app.use( bodyParser.json() );
// for parsing application/x-www-form-urlencoded
app.use( bodyParser.urlencoded( {
    extended: true
} ) );

// read config
clientCode = args[ 2 ];
clientConfig = args[ 3 ];
config = JSON.parse( fs.readFileSync( clientConfig ) );

function updateStatus( res, updateData ) {
     res.render( 'index', {
        "currentState": updateData
    } );
}

function showStatus( res ) {
    var result, cmd;
    cmd = "/sbin/ifconfig";
    result = exec( cmd, function ( err, stdout, stderr ) {
        var result = '';
        if ( stdout ) {
            result += stdout;
        }
        if ( stderr ) {
            result += stderr;
        }
        if ( err ) {
            result += err;
        }
        if ( result ) {
            res.render( 'index', {
                "currentState": result
            } );
        } else {
            res.render( 'index', {
                "currentState": "error"
            } );
        }
    } );
}

// respond with "hello world" when a GET request is made to the homepage
app.get( '/', function ( req, res ) {
    showStatus( res );
} );

// deal wtih a post
app.post( '/update', function ( req, res ) {
    var updateKey;
    winston.log( 'info', "SSID = " + req.body.ssid );
    if ( req.body.ssid && req.body.passKey ) {
        updateKey = {
            ssid: req.body.ssid,
            key: req.body.passKey
        }
    }
    updateStatus( res, updateKey );
} );

options.key = fs.readFileSync( config.keyFile );
options.cert = fs.readFileSync( config.certFile );

secureServer = https.createServer(options, app);
secureServer.listen(config.port);
winston.log( 'info', "Listening on port ${config.port}, not secure!" );
