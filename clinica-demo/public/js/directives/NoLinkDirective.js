(function() {
  function noLinkDirective() {
    return {
      restrict: 'A',
      link: function($scope, $element, $attrs) {
        $element.on('click', function (e) {
          // Detengo la propagación del evento click
          e.preventDefault();
        });
      }
    }
  }

  angular
    .module('clinicaApp')
    .directive('noLinkDirective', noLinkDirective);
})();