(function() {
  function ModalEliminarCtrl($scope, $modalInstance, ruta, AjaxService, RegistrosService) {
    //////////////////////////////////////////
    // ----------OBJETOS INTERNOS---------- //
    //////////////////////////////////////////
    $scope.mensaje = '¿Realmente desea eliminar este registro?';

    $scope.registroSeleccionado = function(value) {
      if (value === undefined) {
        return RegistrosService.registroSeleccionado;
      } else {
        RegistrosService.registroSeleccionado = value;
      };
    }

    $scope.dataRegistros = function(value) {
      if (value === undefined) {
        return RegistrosService.initData.dataRegistros;
      } else {
        RegistrosService.initData.dataRegistros = value;
      };
    }

    $scope.dataPaginador = function(value) {
      if (value === undefined) {
        return RegistrosService.initData.dataPaginador;
      } else {
        RegistrosService.initData.dataPaginador = value;
      };
    }

    $scope.totalRegistros = function(value) {
      if (value === undefined) {
        return RegistrosService.initData.totalRegistros;
      } else {
        RegistrosService.initData.totalRegistros = value;
      };
    }

    //////////////////////////////////////////
    // ----------MÉTODOS INTERNOS---------- //
    //////////////////////////////////////////
    $scope.cancelar = function() {
      $modalInstance.dismiss('close');
    }

    $scope.aceptar = function() {
      var responsePromise = AjaxService.ajaxGet(ruta);

      responsePromise.then(function(data, status, headers, config) {
        $scope.dataRegistros(data.dataRegistros);
        $scope.dataPaginador(data.dataPaginador);
        $scope.totalRegistros(data.totalRegistros);

        $scope.registroSeleccionado(false);
        $modalInstance.dismiss('close');

      }, function(error) {
        console.log(error);
      });
    }

  }

  angular
    .module('clinicaApp')
    .controller('ModalEliminarCtrl', ModalEliminarCtrl);
})();