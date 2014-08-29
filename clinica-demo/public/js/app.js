(function() {
  function config($routeProvider, $interpolateProvider) {
    // Rutas
    $routeProvider.when('/tablas-maestras/colors', {
      templateUrl: 'templates/colors.html',
      controller: 'DataCtrl',
      resolve: {
        data: function(AjaxService) {
          return AjaxService.ajaxGet('/tablas-maestras/colors');
        },
      },
    });

    // Cambio los símbolos {{}} por conflicto con laravel
    $interpolateProvider.startSymbol('//');
    $interpolateProvider.endSymbol('//');
  }

  angular
    .module('clinicaApp', ['ngRoute', 'ui.bootstrap', 'angular-blocks'])
    .config(config);
})();

