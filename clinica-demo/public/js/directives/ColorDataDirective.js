(function() {
  function ColorDataDirective() {
    return {
      restrict: 'EA',
      link: function($scope, $element, $attrs) {
      }
    }
  }

  angular
    .module('clinicaApp')
    .directive('ColorData', ColorDataDirective);
})();