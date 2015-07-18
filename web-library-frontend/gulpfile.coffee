webdriver_update = require('gulp-protractor').webdriver_update

moment    = require 'moment'
pkg       = require './package.json'
gulp_pkg  = require './node_modules/gulp/package.json'

commons =
  gulp      : require('gulp-param')(require('gulp'), process.argv);
  rimraf : require 'gulp-rimraf'
  fs        : require 'fs'

  implementation_version : if process.env.BUILD_NUMBER then pkg.version+' (jb'+ process.env.BUILD_NUMBER+')' else pkg.version+' (bt'+moment().format("YYYYMMDD_hhmmss")+')'

  paths :
    appJs: ['./app/**/*.coffee','./app/**/*.js']
    img:['./app/**/*.png','./app/**/*.gif','./app/**/*.jpg']
    fonts:['./bower_components/bootstrap/fonts/*', './app/fonts/*']
    templates: [
      '!./app/index.jade'
      '!./app/index.html'
      './app/**/*.html'
      './app/**/*.jade'
    ]
    index: ['./app/index.jade']
    

  ngClassifyDefinitions : (file, options) ->
      ##for windows
      return appName: 'youtech.translator' if file.path.indexOf('components\\translator') isnt -1
      return appName: 'youtech.service' if file.path.indexOf('components\\service') isnt -1
      return appName: 'youtech.modal' if file.path.indexOf('components\\modal') isnt -1
      return appName: 'youtech.dashboard' if file.path.indexOf('components\\dashboard') isnt -1
      return appName: 'youtech.request' if file.path.indexOf('components\\request') isnt -1
      return appName: 'youtech.new_request' if file.path.indexOf('components\\new_request') isnt -1
      return appName: 'youtech.file_upload' if file.path.indexOf('components\\file_upload') isnt -1
      return appName: 'omnia.http.errors' if file.path.indexOf('components\\http\\errors') isnt -1
      return appName: 'omnia.http.date_convert' if file.path.indexOf('components\\http\\date_convert') isnt -1
      return appName: 'omnia.date_fix' if file.path.indexOf('components\\date_fix') isnt -1
      return appName: 'omnia.cart_data_poller' if file.path.indexOf('components\\cartData') isnt -1
      ##fol unix
      return appName: 'youtech.translator' if file.path.indexOf('components/translator') isnt -1
      return appName: 'youtech.service' if file.path.indexOf('components/service') isnt -1
      return appName: 'youtech.modal' if file.path.indexOf('components/modal') isnt -1
      return appName: 'youtech.dashboard' if file.path.indexOf('components/dashboard') isnt -1
      return appName: 'youtech.request' if file.path.indexOf('components/request') isnt -1
      return appName: 'youtech.new_request' if file.path.indexOf('components/new_request') isnt -1
      return appName: 'youtech.file_upload' if file.path.indexOf('components/file_upload') isnt -1
      return appName: 'omnia.http.errors' if file.path.indexOf('components/http/errors') isnt -1
      return appName: 'omnia.http.date_convert' if file.path.indexOf('components/http/date_convert') isnt -1
      return appName: 'omnia.date_fix' if file.path.indexOf('components/date_fix') isnt -1
      return appName: 'omnia.cart_data_poller' if file.path.indexOf('components/cartData') isnt -1

      return appName: 'youtech'

commons.gulp.task 'dir_clean', ->
  commons.gulp.src ['dist/', 'mvn_dist/', 'tests/reports/']
    .pipe commons.rimraf
      read: false
      force: true

commons.gulp.task 'clean', ['dir_clean'], ->
  commons.gulp.src commons.paths.i18n
    .pipe commons.gulp.dest './dist/js/i18n'

commons.gulp.task 'manifest', ['clean'],  ->
  commons.fs.mkdir('./dist/META-INF/')
  commons.fs.writeFile(
    './dist/META-INF/MANIFEST.MF'
    [
      'Manifest-Version: 1.0'
      'Implementation-Version: ' + commons.implementation_version
      'Built-By: ' + (process.env.USERNAME || process.env.USER)
      'Built-Date: ' + moment().format()
      'Class-Path: '
      'Created-By: ' + gulp_pkg.name + " " + gulp_pkg.version
    ].join('\n')
  )
commons.gulp.task 'update_driver', ->
  webdriver_update ->
    console.log("updated driver")

gutil      = require 'gulp-util'
connect    = require 'gulp-connect'
gulpif     = require 'gulp-if'
coffee     = require 'gulp-coffee'
concat     = require 'gulp-concat'
tplCache   = require 'gulp-angular-templatecache'
jade       = require 'gulp-jade'
less       = require 'gulp-less'
sourcemaps = require 'gulp-sourcemaps'
ngClassify = require 'gulp-ng-classify'
coffeelint = require 'gulp-coffeelint'
rimraf     = require 'gulp-rimraf'
backend    = require './backend/app'

protractor = require('gulp-protractor').protractor

paths.libJs = [
  './bower_components/ng-file-upload/angular-file-upload-shim.js'
  './bower_components/angular/angular.js'
  './bower_components/angular-cookies/angular-cookies.js'
  './bower_components/angular-ui-router/release/angular-ui-router.js'
  './bower_components/angular-animate/angular-animate.js'
  './bower_components/angular-translate/angular-translate.js'
  './bower_components/angular-svg-round-progressbar/roundProgress.js'
  './bower_components/angular-bootstrap/ui-bootstrap-tpls.js'
  './bower_components/underscore/underscore.js'
  './bower_components/ladda-bootstrap/dist/spin.js'
  './bower_components/ladda-bootstrap/dist/ladda.js'
  './bower_components/ui-ladda/ladda.js'
  './bower_components/angular-growl-v2/build/angular-growl.js'
  './bower_components/angular-dynamic-locale/src/tmhDynamicLocale.js'
  './bower_components/ng-file-upload/angular-file-upload.js'
  './bower_components/angular-promise-tracker/promise-tracker.js'
  './bower_components/angular-promise-tracker/promise-tracker-http-interceptor.js'
  './bower_components/angular-scroll/angular-scroll.js'
  './bower_components/moment/min/moment-with-locales.js'
]
paths.libCss = [
  './bower_components/ladda-bootstrap/dist/ladda-themeless.css'
  './bower_components/angular-growl-v2/build/angular-growl.css'
  './bower_components/**/*.css'
  '!./bower_components/bootstrap/**/*.css'
  '!./app/css/less/print.less'
]

paths.deploy = [
  './dist/**/*.*'
]

gulp.task 'appJs',  ->
  gulp.src paths.appJs #tutte le sottocartelle di app con file .coffee o .js
    .pipe coffeelint().on 'error', gutil.log
    .pipe ngClassify(ngClassifyDefinitions) .on 'error', gutil.log
    .pipe coffeelint.reporter().on 'error', gutil.log
    .pipe sourcemaps.init().on 'error', gutil.log
    .pipe (gulpif /[.]coffee$/, coffee(bare: true).on 'error', gutil.log).on 'error', gutil.log
    .pipe concat('app.js').on 'error', gutil.log
    .pipe sourcemaps.write('./maps').on 'error', gutil.log
    .pipe gulp.dest('./dist/js').on 'error', gutil.log

gulp.task 'libJs', ->
  gulp.src paths.libJs
    .pipe concat 'lib.js'
    .pipe gulp.dest './dist/js'

gulp.task 'index', ->
  gulp.src paths.index
    .pipe gulpif /[.]jade$/, jade(
      doctype: 'html'
      locals: { 'version' : implementation_version }).on 'error', gutil.log
    .pipe gulp.dest './dist/'

gulp.task 'templates', ->
  gulp.src paths.templates
    .pipe gulpif /[.]jade$/, jade(doctype: 'html').on 'error', gutil.log
    .pipe tplCache 'templates.js', { standalone:true }
    .pipe gulp.dest './dist/js/'

gulp.task 'appCss', ->
  gulp.src paths.appCss
    .pipe gulpif /[.]less$/, less()
    .on 'error', gutil.log
    .pipe concat 'youtech.css'
    .pipe gulp.dest './dist/css'


gulp.task 'tests', ['update_driver'], ->
  gulp.src ['tests/e2e/**/*.spec.coffee']
    .pipe protractor
      configFile: 'tests/protractor.conf.coffee'
      #configFile: 'tests/protractor_headless.conf.coffee'

gulp.task 'printCss', ->
  gulp.src paths.printCss
    .pipe gulpif /[.]less$/, less()
    .on 'error', gutil.log
    .pipe concat 'print.css'
    .pipe gulp.dest './dist/css'

gulp.task 'libCss', ->
  gulp.src paths.libCss
    .pipe concat 'lib.css'
    .pipe gulp.dest './dist/css'

gulp.task 'img',  ->
  gulp.src paths.img
    .pipe gulp.dest './dist'

gulp.task 'fonts',  ->
  gulp.src paths.fonts
    .pipe gulp.dest './dist/fonts'

gulp.task 'connect', ->
  backend.set "port", 8011
  server = backend.listen(backend.get("port"), ->
    # debug "Express server listening on port " + server.address().port
    connect.server
      root: ['dist']
      port: 8010
      livereload: true
      middleware: (connect,o) ->
        [
          (->
            url = require 'url'
            proxy = require 'proxy-middleware'
            options = url.parse 'http://localhost:8011/v1'
            options.route = '/v1'
            proxy options
          )(),
          (->
            url = require 'url'
            proxy = require 'proxy-middleware'
            options = url.parse 'http://localhost:8011/ecm'
            options.route = '/ecm'
            proxy options
          )(),
          (->
            url = require 'url'
            proxy = require 'proxy-middleware'
            options = url.parse 'http://localhost:8011/sharedws'
            options.route = '/sharedws'
            proxy options
          )(),
          (->
            url = require 'url'
            proxy = require 'proxy-middleware'
            options = url.parse 'http://localhost:8011/NDCSWebServices'
            options.route = '/NDCSWebServices'
            proxy options
          )()
        ]
     return
  )

gulp.task 'connect-liberty', ->
  process.env.NODE_TLS_REJECT_UNAUTHORIZED = "0" # Avoids DEPTH_ZERO_SELF_SIGNED_CERT error for self-signed certs
  backend.set "port", 8011
  server = backend.listen(backend.get("port"), ->
    # debug "Express server listening on port " + server.address().port
    connect.server
      root: ['dist']
      port: 8010
      livereload: true
      middleware: (connect,o) ->
        [
          (->
            url = require 'url'
            proxy = require 'proxy-middleware'
            options = url.parse 'https://localhost:9444/youtech/v1/'
            options.route = '/v1'
            proxy options
          )(),
          (->
            url = require 'url'
            proxy = require 'proxy-middleware'
            options = url.parse 'https://localhost:9444/sharedws'
            options.route = '/sharedws'
            proxy options
          )()
        ]
     return
  )


gulp.task 'watch', ->
  # reload connect server on built file change
  gulp.watch [
    'dist/**/*.html'
    'dist/**/*.js'
    'dist/**/*.css'
  ], (event) ->
    gulp.src event.path
      .pipe connect.reload()
  # watch files to build
  gulp.watch [
    './app/**/*.coffee',
    './app/**/*.js'],
    ['appJs']
  gulp.watch [
    '!./app/index.jade',
    '!./app/index.html',
    './app/**/*.jade',
    './app/**/*.html'],
    ['templates']
  gulp.watch ['./app/**/*.less','./app/**/*.css'], ['appCss']
  gulp.watch ['./app/**/*.less','./app/**/*.css'], ['printCss']
  gulp.watch ['./app/index.jade', './app/index.html'], ['index']
  return

gulp.task 'libMap', ->
  # copy sourcemaps for each libs
  gulp.src [
    './bower_components/bootstrap/dist/css/bootstrap.css.map'
    './bower_components/angular-growl-v2/build/angular-growl.css'
  ]
  .pipe gulp.dest './dist/css'

gulp.task 'deployOnChanges', (destination) ->
  gulp.watch [
    'dist/**/*.html'
    'dist/**/*.js'
    'dist/**/*.css'
  ], ['deploy'], destination

gulp.task 'deploy', (destination) ->
  gulp.src paths.deploy
    .pipe gulp.dest destination #"C:\\Dev\\ws\\ducati-survey-luna\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp2\\survey-war\\"

gulp.task 'commons', [
  'appJs',
  'libJs',
  'index',
  'templates',
  'appCss',
  'printCss',
  'libCss',
  'img',
  'fonts',
  'libMap',
  'watch'
]

gulp.task 'default', ['commons', 'connect-liberty']
gulp.task 'node-be', ['commons', 'connect']
