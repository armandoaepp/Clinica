(function() {
  function ModalDataCtrl($scope, $modal, $modalInstance, RegistrosService, AjaxService, data, ruta, accion) {
    //////////////////////////////////////////
    // ----------OBJETOS INTERNOS---------- //
    //////////////////////////////////////////
    $scope.dataFormulario = data.dataFormulario;

    $scope.registroSeleccionado = function(value) {
      if (value === undefined) {
        return RegistrosService.registroSeleccionado;
      } else {
        RegistrosService.registroSeleccionado = value;
      };
    }

    //////////////////////////////////////////
    // ----------MÉTODOS INTERNOS---------- //
    //////////////////////////////////////////
    $scope.cancel = function() {
      $modalInstance.dismiss('cancel');
    }

    $scope.submit = function() {
      var dataSubmit = {};

      for (var i = 0; i < $scope.dataFormulario.campos.length; i++) {
        var campo = $scope.dataFormulario.campos[i];
        dataSubmit[campo.name] = campo.value;
      };

      dataSubmit = $.param(dataSubmit);
      var responsePromise = AjaxService.ajaxPostJson(ruta, dataSubmit);

      responsePromise.then(function(data, status, headers, config) {
        RegistrosService.initData.dataRegistros = data.dataRegistros;

        if (accion !== 'editar') {
          RegistrosService.initData.dataPaginador = data.dataPaginador;
          RegistrosService.initData.totalRegistros = data.totalRegistros;
        };

        $scope.registroSeleccionado(false);
        $modalInstance.dismiss('cancel');

      }, function(error) {
        console.log(error);
      });
    }

  }

  angular
    .module('clinicaApp')
    .controller('ModalDataCtrl', ModalDataCtrl);
})();