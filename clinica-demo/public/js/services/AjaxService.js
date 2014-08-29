(function() {
  function AjaxService($http) {

    this.ajaxGet = function(ruta) {
      var promise = $http.get(ruta).then(function(response) {
        return response.data;
      });
      return promise;
    }

    this.ajaxPostJson = function(ruta, data) {
      var promise = $http.post(ruta, data, {
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
      }).then(function(response) {
        return response.data;
      });
      return promise;
    }

  }

  angular
    .module('clinicaApp')
    .service('AjaxService', AjaxService);
})();