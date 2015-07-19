angular.module("templates", []).run(["$templateCache", function($templateCache) {$templateCache.put("components/catalog/catalog.html","<nav class=\"navbar navbar-inverse navbar-fixed-top\"><div class=\"container\"><div class=\"navbar-header\"><a href=\"#/catalog\" class=\"navbar-brand\">Web Library</a></div><div id=\"navbar\"><ul class=\"nav navbar-nav\"><li class=\"active\"><a href=\"#/catalog\">catalog</a></li></ul></div><!-- /.nav-collapse--></div></nav><div class=\"container\"><h1></h1><p class=\"lead\">Lista Autori<table class=\"table table-striped\"><thead><tr><th>Autore</th><th>Età</th><th>Nickname</th><th>ID</th><th></th></tr></thead><tbody><tr ng-repeat=\"author in authors\"><td>{{  author.name }}</td><td>{{ author.age }}</td><td># - {{ author.id }}</td><td><button ng-click=\"select(author)\"><span ng-hide=\"isSelected(author)\" class=\"glyphicon glyphicon-plus-sign\"></span><span ng-show=\"isSelected(author)\" class=\"glyphicon glyphicon-minus-sign\"></span></button></td></tr></tbody></table></p></div><!-- /.container-->\n\n");
$templateCache.put("components/login/login.html","<div class=\"container\"><form ng-submit=\"login()\" class=\"form-signin\"><h2 class=\"form-signin-heading\">Please sign in</h2>        <label for=\"inputEmail\" class=\"sr-only\">Email address</label>        <input id=\"inputEmail\" type=\"email\" placeholder=\"Email address\" required autofocus ng-model=\"user.email\" class=\"form-control\">        <label for=\"inputPassword\" class=\"sr-only\">Password</label>        <input id=\"inputPassword\" type=\"password\" placeholder=\"Password\" required ng-model=\"user.password\" class=\"form-control\">        <button type=\"submit\" class=\"btn btn-lg btn-primary btn-block\">Sign in</button></form></div>");
$templateCache.put("components/login/welcome.html","<div class=\"modal-header\"><h3 class=\"modal-title\">Welcome!</h3>        <div class=\"modal-body\"></div>{{ user.email }}\nYou are logged in<div class=\"modal-footer\"><button ng-click=\"openCatalog()\" class=\"btn btn-primary\">OK</button></div></div>");}]);