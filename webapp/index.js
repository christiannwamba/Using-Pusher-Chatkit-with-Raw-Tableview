// Pull in the libraries
const express    = require('express');
const bodyParser = require('body-parser');
const app        = express();
const Chatkit    = require('pusher-chatkit-server');
const chatkit    = new Chatkit.default(require('./config.js'))

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: false }));

// Creates a new user
app.post('/login', (req, res) => {
    let username = req.body.username;
    chatkit.createUser(username, username).then(r => res.json({username})).catch(e => res.json(e))
})

// Fetch a token from Chatkit
app.post('/authenticate', (req, res) => {
    let grant_type = req.body.grant_type
    res.json(chatkit.authenticate({grant_type}, req.query.user_id))
});

// Index
app.get('/', (req, res) => { res.json("It works!") });

// 404!
app.use((req, res, next) => {
    let err = new Error('Not Found');
    err.status = 404;
    next(err);
});

// Run it!
app.listen(4000, function(){
    console.log('App listening on port 4000!')
});
