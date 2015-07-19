gulp      = require('gulp-param')(require('gulp'), process.argv);
del       = require 'del'
fs        = require 'fs'
moment    = require 'moment'

pkg       = require './package.json'
gulp_pkg  = require './node_modules/gulp/package.json'

implementation_version = pkg.version+' (bt'+moment().format("YYYYMMDD_hhmmss")+')'

ngClassifyDefinitions = (file, options) ->
    ##for Unix
    return appName: 'library.login' if file.path.indexOf('components/login') isnt -1
    return appName: 'library.catalog' if file.path.indexOf('components/catalog') isnt -1
    return appName: 'library'

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


gulp.task 'clean:dist', ->
  del 'dist/**/*'


#protractor = require('gulp-protractor').protractor#
paths = {}
paths =
  appCss    : ['./app/css/**/*.less','./app/css/**/*.css' ]
  appJs     : ['./app/**/*.coffee','./app/**/*.js']
  img       : ['./app/**/*.png','./app/**/*.gif','./app/**/*.jpg']
  fonts     : ['./bower_components/bootstrap/fonts/*', './app/fonts/*']
  templates : [
      '!./app/index.jade'
      '!./app/index.html'
      '!./app/jade_includes/**/*.jade'
      './app/**/*.html'
      './app/**/*.jade'
  ]
  index     : ['./app/index.jade']
  dist      : ['../web-library-b/src/main/webapp/']
#i18n is not enabled
#    i18n:[
#      './bower_components/angular-i18n/angular-locale*it-it*',
#      './bower_components/angular-i18n/angular-locale*en.*',
#      './bower_components/angular-i18n/angular-locale*en-us*',
#      './bower_components/angular-i18n/angular-locale*ja-jp*',
#      './bower_components/angular-i18n/angular-locale*fr-fr*',
#      './bower_components/angular-i18n/angular-locale*de-de*',
#      './bower_components/angular-i18n/angular-locale*es-es*',
#      './bower_components/angular-i18n/angular-locale*pt-br*'
#    ]
  libJs     : [
    './bower_components/angular/angular.js'
    './bower_components/angular-ui-router/release/angular-ui-router.js'
 #   './bower_components/angular-translate/angular-translate.js'
    './bower_components/angular-bootstrap/ui-bootstrap-tpls.js'
    './bower_components/underscore/underscore.js'
    './bower_components/ladda-bootstrap/dist/spin.js'
    './bower_components/ladda-bootstrap/dist/ladda.js'
    './bower_components/ui-ladda/ladda.js'
    './bower_components/angular-growl/build/angular-growl.js'
  ]
  libCss    : [
    './bower_components/angular-growl/build/angular-growl.css'
    './bower_components/**/*.css'
  ]
  deploy    : ['./dist/**/*.*']



gulp.task 'appJs',  ->
  gulp.src paths.appJs #tutte le sottocartelle di app con file .coffee o .js
    .pipe coffeelint().on 'error', gutil.log
    .pipe ngClassify(ngClassifyDefinitions) .on 'error', gutil.log
    .pipe coffeelint.reporter().on 'error', gutil.log
    .pipe sourcemaps.init().on 'error', gutil.log
    .pipe (gulpif /[.]coffee$/, coffee(bare: true).on 'error', gutil.log).on 'error', gutil.log
    .pipe concat('app.js').on 'error', gutil.log
    .pipe sourcemaps.write('./maps').on 'error', gutil.log
    .pipe gulp.dest('./dist/js').on 'error', gutil.log#

gulp.task 'libJs', ->
  gulp.src paths.libJs
    .pipe concat 'lib.js'
    .pipe gulp.dest './dist/js'#

gulp.task 'index', ->
  gulp.src paths.index
    .pipe gulpif /[.]jade$/, jade(
      doctype: 'html'
      locals: { 'version' : implementation_version }).on 'error', gutil.log
    .pipe gulp.dest './dist/'#

gulp.task 'templates', ->
  gulp.src paths.templates
    .pipe gulpif /[.]jade$/, jade(doctype: 'html').on 'error', gutil.log
    .pipe tplCache 'templates.js', { standalone:true }
    .pipe gulp.dest './dist/js/'#

gulp.task 'appCss', ->
  gulp.src paths.appCss
    .pipe gulpif /[.]less$/, less()
    .on 'error', gutil.log
    .pipe concat 'library.css'
    .pipe gulp.dest './dist/css'#


#gulp.task 'tests', ['update_driver'], ->
#  gulp.src ['tests/e2e/**/*.spec.coffee']
#    .pipe protractor
#      configFile: 'tests/protractor.conf.coffee'
#      #configFile: 'tests/protractor_headless.conf.coffee'#

#gulp.task 'printCss', ->
#  gulp.src paths.printCss
#    .pipe gulpif /[.]less$/, less()
#    .on 'error', gutil.log
#    .pipe concat 'print.css'
#    .pipe gulp.dest './dist/css'#

gulp.task 'libCss', ->
  gulp.src paths.libCss
    .pipe concat 'lib.css'
    .pipe gulp.dest './dist/css'#

gulp.task 'img',  ->
  gulp.src paths.img
    .pipe gulp.dest './dist'#

gulp.task 'fonts',  ->
  gulp.src paths.fonts
    .pipe gulp.dest './dist/fonts'#

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
  gulp.watch ['./app/index.jade', './app/index.html'], ['index']
  return#

#gulp.task 'libMap', ->
#  # copy sourcemaps for each libs
#  gulp.src [
#    './bower_components/bootstrap/dist/css/bootstrap.css.map'
#    './bower_components/angular-growl-v2/build/angular-growl.css'
#  ]
#  .pipe gulp.dest './dist/css'#

#gulp.task 'deployOnChanges', (destination) ->
#  gulp.watch [
#    'dist/**/*.html'
#    'dist/**/*.js'
#    'dist/**/*.css'
#  ], ['deploy'], destination#

#gulp.task 'deploy', (destination) ->
#  gulp.src paths.deploy
#    .pipe gulp.dest destination #"C:\\Dev\\ws\\ducati-survey-luna\\.metadata\\.plugins\\org.eclipse.wst.server.core\\tmp2\\survey-war\\"#

gulp.task 'commons', [
  'libCss',
  'libJs',
  'appJs',
  'index',
  'templates',
  'appCss',
  'img',
  'fonts',
  'watch'
]

gulp.task 'prod', [

]

gulp.task 'default', ['commons', 'connect']
