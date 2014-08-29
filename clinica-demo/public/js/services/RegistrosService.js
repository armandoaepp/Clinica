(function() {
  function RegistrosService($http) {

    this.initData = {};
    this.paginaActual = 1;
    this.camposBusqueda = {};
    this.registroSeleccionado;
    this.botoneraAccion = '';

  }

  angular
    .module('clinicaApp')
    .service('RegistrosService', RegistrosService);
})();