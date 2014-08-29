(function() {
  function DataCtrl(data, $scope, AjaxService, RegistrosService) {
    //////////////////////////////////////////
    // ----------OBJETOS INTERNOS---------- //
    //////////////////////////////////////////

    RegistrosService.initData = data;

    $scope.formData = {};
    $scope.formAccion;
    $scope.procesando = false;


    //////////////////////////////////////////
    // ----------MÉTODOS INTERNOS---------- //
    //////////////////////////////////////////
  }

  angular
    .module('clinicaApp')
    .controller('DataCtrl', DataCtrl);
})();