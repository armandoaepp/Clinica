(function() {
  function PaginadorCtrl($scope, RegistrosService, AjaxService) {
    //////////////////////////////////////////
    // ----------OBJETOS INTERNOS---------- //
    //////////////////////////////////////////

    $scope.paginaActual = function(value) {
      if (value) {
        RegistrosService.paginaActual = value;
      } else {
        return RegistrosService.paginaActual;
      };
    }

    $scope.camposBusqueda = function(value) {
      if (value) {
        RegistrosService.camposBusqueda = value;
      } else {
        return RegistrosService.camposBusqueda;
      };
    }

    $scope.dataPaginador = function(value) {
      if (value) {
        RegistrosService.initData.dataPaginador = value;
      } else {
        return RegistrosService.initData.dataPaginador;
      };
    }

    $scope.dataRutas = function(value) {
      if (value) {
        RegistrosService.initData.dataRutas = value;
      } else {
        return RegistrosService.initData.dataRutas;
      };
    }

    $scope.totalRegistros = function(value) {
      if (value) {
        RegistrosService.initData.totalRegistros = value;
      } else {
        return RegistrosService.initData.totalRegistros;
      };
    }


    //////////////////////////////////////////
    // ----------MÉTODOS INTERNOS---------- //
    //////////////////////////////////////////

    $scope.paginar = function(boton) {
      $scope.asignarBotonActivo(boton);
      var pagina = boton.pagina;
      RegistrosService.paginaActual = pagina;

      var objData = {
        'pagina': pagina,
        'camposBusqueda': $scope.camposBusqueda(),
      };


      var data = $.param(objData);
      var responsePromise = AjaxService.ajaxPostJson($scope.dataRutas().filtrar, data);

      responsePromise.then(function(data, status, headers, config) {
        $scope.dataRegistros(data.dataRegistros);
        $scope.dataPaginador(data.dataPaginador);
        $scope.totalRegistros(data.totalRegistros);

        $scope.generarTextoPaginacion(data.dataRegistros);

      }, function(error) {
        console.log(error);
      });
    }

    $scope.asignarBotonActivo = function(boton) {
      var dataPaginador = $scope.dataPaginador();

      for (var i = 0; i < dataPaginador.length; i++) {
        dataPaginador[i].activo = false;
      };

      if (boton.inicial || boton.final) {
        for (var i = 0; i < dataPaginador.length; i++) {
          if (dataPaginador[i].pagina == boton.pagina && dataPaginador[i] != boton) {
            dataPaginador[i].activo = true;
          };
        };
      } else {
        boton.activo = true;
      };

      $scope.dataPaginador(dataPaginador);
    };

    $scope.generarTextoPaginacion = function(dataRegistros) {
      var texto = '';

      if (dataRegistros.length > 0) {
        var regInicio = dataRegistros[0].index;
        var regFin = dataRegistros[dataRegistros.length - 1].index;

        texto = 'Registros ' + regInicio + ' - ' + regFin + ' de ' + $scope.totalRegistros();
      };

      return texto;
    }

  }

  angular
    .module('clinicaApp')
    .controller('PaginadorCtrl', PaginadorCtrl);
})();