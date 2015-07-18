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
    appCss: ['./app/css/less/youtech.less']
    printCss: ['./app/css/less/print.less']
    img:['./app/**/*.png','./app/**/*.gif','./app/**/*.jpg']
    fonts:['./bower_components/bootstrap/fonts/*', './app/fonts/*']
    templates: [
      '!./app/index.jade'
      '!./app/index.html'
      '!./app/jade_includes/**/*.jade'
      './app/**/*.html'
      './app/**/*.jade'
    ]
    index: ['./app/index.jade']
    i18n:[
      './bower_components/angular-i18n/angular-locale*it-it*',
      './bower_components/angular-i18n/angular-locale*en.*',
      './bower_components/angular-i18n/angular-locale*en-us*',
      './bower_components/angular-i18n/angular-locale*ja-jp*',
      './bower_components/angular-i18n/angular-locale*fr-fr*',
      './bower_components/angular-i18n/angular-locale*de-de*',
      './bower_components/angular-i18n/angular-locale*es-es*',
      './bower_components/angular-i18n/angular-locale*pt-br*'
    ]

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

module.exports = commons
