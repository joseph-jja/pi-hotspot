var express = require( 'express' ),
    server,
    secureServer,
    args = process.argv,
    bodyParser = require( 'body-parser' ),
    winston = require( 'winston' ),
    exec = require( "child_process" ).exec,
    exphbs = require( 'express-handlebars' ),
    app = express(),
    https = require( 'https' ),
    fs = require( "fs" ),
    clientCode,
    options = {},
    clientConfig,
    config;

app.engine( '.hbs', exphbs( {
    defaultLayout: 'baseLayout',
    extname: '.hbs'
} ) );opt

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
    winston.log( 'info', "Key = " + req.body.changeModeKey );
    if ( req.body.changeModeKey && req.body.changeModeKey == config.changeModeKey ) {
        updateKey = req.body.changeModeKey;
    }
    updateStatus( res, updateKey );
} );

options.key = config.keyFile;
options.cert = config.certFile;

secureServer = https.createServer(options, app);
secureServer.listen(config.port);
winston.log( 'info', "Listening on port ${config.port}, not secure!" );
