(function() {
  function ModalAlertaCtrl($scope, $modalInstance, RegistrosService) {
    //////////////////////////////////////////
    // ----------OBJETOS INTERNOS---------- //
    //////////////////////////////////////////
    $scope.mensaje = 'No ha seleccionado ningún registro';

    $scope.registroSeleccionado = function(value) {
      if (value) {
        RegistrosService.registroSeleccionado = value;
      } else {
        return RegistrosService.registroSeleccionado;
      };
    }

    //////////////////////////////////////////
    // ----------MÉTODOS INTERNOS---------- //
    //////////////////////////////////////////
    $scope.aceptar = function() {
      $scope.registroSeleccionado(undefined);
      $modalInstance.dismiss('close');
    }

  }

  angular
    .module('clinicaApp')
    .controller('ModalAlertaCtrl', ModalAlertaCtrl);
})();