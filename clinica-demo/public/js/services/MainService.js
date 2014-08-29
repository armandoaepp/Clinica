(function() {
  function MainService($http) {
    var initData = {};

    var mainService = {
      getAsync: function(ruta) {
        var promise = $http.get(ruta).then(function(response) {
          return response.data;
        });
        return promise;
      },
      postAsync: function(ruta, data) {
        var promise = $http.post(ruta, data, {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        }).then(function(response) {
          return response.data;
        });
        return promise;
      },
      processForm: function(accion, data) {
        var promise = $http.post(accion, data, {
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
          },
        }).then(function(response) {
          return response.data;
        });
        return promise;
      },
      setInitData: function(data) {
        initData = data;
      },
      getInitData: function() {
        return initData;
      },
    }
    return mainService;
  }

  angular
    .module('clinicaApp')
    .service('MainService', MainService);
})();