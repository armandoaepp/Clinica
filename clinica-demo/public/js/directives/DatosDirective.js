(function() {
  function datosDirective() {
    return {
      restrict: 'A',
      link: function($scope, $element, $attrs) {
      }
    }
  }

  angular
    .module('clinicaApp')
    .directive('datosDirective', datosDirective);
})();