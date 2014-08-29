(function() {
  function MenuCtrl($scope, $location) {

    $scope.verificar = function(item) {
      if (item.subMenus) {
        return false;
      } else {
        return true;
      };
    }

    $scope.go = function(ruta) {
      $location.path('/tablas-maestras/colors');
    }

    $scope.dataMenus = angular.element('.data-menu').data('menu');
  }

  angular
    .module('clinicaApp')
    .controller('MenuCtrl', MenuCtrl);
})();
