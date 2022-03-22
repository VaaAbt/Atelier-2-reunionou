var createError = require('http-errors');
var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var eventsRouter = require('./routes/events');

var app = express();

// view engine setup
app.set('views', path.join(__dirname, 'views'));
app.set('view engine', 'ejs');

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/events', eventsRouter);
/* ----- GESTION DES MAUVAISES URL's ------ */
app.use('*', function(req, res, next){
  res.status(400).json({
    "type": "error",
    "error": "400",
    "message": "L'URL suivante n'est pas correct : "+req.protocol + '://' + req.get('host') + req.originalUrl,
  });
});
// catch 404 and forward to error handler
app.use(function(req, res, next) {
  next(createError(404));
});
// error handler
app.use(function(err, req, res, next) {
  // set locals, only providing error in development
  let message = err.message;
  let error = req.app.get('env') === 'development' ? err : {};

  // render the error page
  res.status(500).json({'message': message, 'error': error});
});

module.exports = app;