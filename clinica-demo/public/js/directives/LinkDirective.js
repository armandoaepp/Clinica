(function() {
  function linkDirective() {
    return {
      restrict: 'A',
      link: function($scope, $element, $attrs) {
        $element.on('click', function (e) {
          // Detengo la propagación del evento click, pero no detiene la propagación en angular
          e.preventDefault();
        });
      }
    }
  }

  angular
    .module('clinicaApp')
    .directive('linkDirective', linkDirective);
})();