# required libraries
express = require('express')
http = require('http')
path = require('path')
fs = require('fs')
nap = require('nap')
coffee = require('coffee-script')
less = require('less')

# directory paths
publicDir = path.join(__dirname, 'public')
viewDir = path.join(__dirname, 'views')
dataDir = path.join(__dirname, 'data')

# setup server
app = express()
port = process.env.PORT || 3000

app.configure ->
  app.set 'port', port
  app.set 'views', viewDir
  app.set 'view engine', 'jade'
  app.use express.favicon()
  app.use express.logger('dev')
  app.use express.bodyParser()
  app.use express.methodOverride()
  app.use app.router
  app.use express.static(publicDir)

app.configure 'development', -> app.use express.errorHandler()

app.get '/', (req, res) -> res.render 'index',
  title: 'Retweet Visualization'
  nap: nap
  retweets: JSON.stringify(retweets)

http.createServer(app).listen port, -> console.log("Express server listening on port #{port}")

# setup assets
nap({
  publicDir: '/public'
  assets: {
    js: {
      all: [
        '/public/vendor/jquery.js'
        '/public/vendor/bootstrap/js/bootstrap.js'
        '/public/vendor/d3.js'
        '/public/vendor/angular/angular.js'
        '/public/vendor/angular-ui/angular-ui.js'
        '/public/vendor/select2/select2.js'
        '/public/js/visualization_controller.coffee'
        '/public/js/tweet_merge.coffee'
        '/public/js/distance_from_origin.coffee'
        '/public/js/force_directed_graph.coffee'
        '/public/js/application.coffee'
      ]
    },
    css: {
      all: [
        '/public/vendor/bootstrap/css/bootstrap.css'
        '/public/vendor/angular-ui/angular-ui.css'
        '/public/vendor/select2/select2.css'
        '/public/css/application.less'
      ]
    }
  }
})

# read retweets
retweets = []
fs.readdir dataDir, (error, files) ->
  throw error if error?
  files.forEach (file) ->
    fs.readFile path.join(dataDir, file), (error, json) ->
      throw error if error?
      retweets.push JSON.parse(json)
