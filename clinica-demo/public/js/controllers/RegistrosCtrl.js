(function() {
  function RegistrosCtrl($scope, AjaxService, RegistrosService) {
    //////////////////////////////////////////
    // ----------OBJETOS INTERNOS---------- //
    //////////////////////////////////////////

    $scope.dataRutas = function(value) {
      if (value === undefined) {
        return RegistrosService.initData.dataRutas;
      } else {
        RegistrosService.initData.dataRutas = value;
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

    $scope.paginaActual = function(value) {
      if (value === undefined) {
        return RegistrosService.paginaActual;
      } else {
        RegistrosService.paginaActual = value;
      };
    }

    $scope.registroSeleccionado = function(value) {
      if (value === undefined) {
        return RegistrosService.registroSeleccionado;
      } else {
        RegistrosService.registroSeleccionado = value;
      };
    }

    $scope.camposBusqueda = function(value) {
      if (value === undefined) {
        return RegistrosService.camposBusqueda;
      } else {
        RegistrosService.camposBusqueda = value;
      };
    }


    //////////////////////////////////////////
    // ----------MÉTODOS INTERNOS---------- //
    //////////////////////////////////////////

    $scope.seleccionarRegistro = function(registro) {
      if (registro.selected) {
        registro.selected = false;
        $scope.registroSeleccionado(false);

      } else {
        for (var i = 0; i < $scope.dataRegistros().length; i++) {
          $scope.dataRegistros()[i].selected = false;
        };

        registro.selected = true;
        $scope.registroSeleccionado(registro);
      };
    }

    $scope.buscar = function() {
      $scope.paginaActual(1);

      var objData = {
        'pagina': $scope.paginaActual(),
        'camposBusqueda': $scope.camposBusqueda(),
      };

      var data = $.param(objData);
      var responsePromise = AjaxService.ajaxPostJson($scope.dataRutas().filtrar, data);

      responsePromise.then(function(data, status, headers, config) {
        $scope.dataRegistros(data.dataRegistros);
        $scope.dataPaginador(data.dataPaginador);
        $scope.totalRegistros(data.totalRegistros);

      }, function(error) {
        console.log(error);
      });
    }

  }

  angular
    .module('clinicaApp')
    .controller('RegistrosCtrl', RegistrosCtrl);
})();