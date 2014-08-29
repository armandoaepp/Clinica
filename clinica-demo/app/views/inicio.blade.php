<!DOCTYPE html>
<html lang="es" ng-app="clinicaApp">
<head>
  <meta charset="UTF-8">
  <title>Clinica</title>
  {{-- Estilos --}}
  {{ HTML::style('third-party/bootstrap/css/bootstrap.min.css') }}
  {{ HTML::style('css/my-bootstrap.css') }}
  {{ HTML::style('css/base.css') }}
  {{ HTML::style('css/data.css') }}
  {{-- Google Fonts --}}
  {{ HTML::style('http://fonts.googleapis.com/css?family=Source+Sans+Pro:300,400,600,700') }}
</head>
<body>
  <div class="container-fluid">
  </div>
  <div class="container-fluid main-content">
    <div class="row">
      <div class="col-lg-2 col-sidebar" ng-controller="MenuCtrl as menu">
        <div class="cont-main-logo">
          <img src="{{ asset('img/logo.png') }}" alt="Clínica" class="main-logo">
          <span class="nombre">Clínica</span>
        </div>
        <div class="data-menu" data-menu='{{ $jsonMenus }}'></div>
        <accordion close-others="true">
          <accordion-group is-disabled="verificar(menu)" ng-repeat="menu in dataMenus"><div class="include" ng-include="'templates/menu.html'"></div></accordion-group>
        </accordion>
      </div>
      <div class="col-lg-10 col-content">
        <div class="row main-header">
          <div class="col-lg-12">
          </div>
        </div>
        <div class="row data-content">
          <div class="col-lg-12" datos-directive>
            <div ng-view></div>
          </div>
        </div>
      </div>
    </div>
  </div>

  {{-- Scripts --}}
  {{ HTML::script('third-party/jquery/js/jquery-2.1.1.min.js') }}
  {{ HTML::script('third-party/angular-js/angular.min.js') }}
  {{ HTML::script('third-party/angular-js/angular-route.min.js') }}
  {{ HTML::script('third-party/angular-blocks/angular-blocks.js') }}
  {{-- {{ HTML::script('third-party/bootstrap/js/bootstrap.min.js') }} --}}
  {{ HTML::script('third-party/ui-bootstrap/ui-bootstrap-tpls-0.11.0.min.js') }}
  {{-- Mis Stripts --}}
  {{ HTML::script('js/app.js') }}
  {{ HTML::script('js/services/AjaxService.js') }}
  {{ HTML::script('js/services/RegistrosService.js') }}
  {{ HTML::script('js/directives/LinkDirective.js') }}
  {{ HTML::script('js/directives/ColorDataDirective.js') }}
  {{ HTML::script('js/directives/NoLinkDirective.js') }}
  {{ HTML::script('js/directives/DatosDirective.js') }}
  {{ HTML::script('js/controllers/MenuCtrl.js') }}
  {{ HTML::script('js/controllers/DataCtrl.js') }}
  {{ HTML::script('js/controllers/BotoneraCtrl.js') }}
  {{ HTML::script('js/controllers/RegistrosCtrl.js') }}
  {{ HTML::script('js/controllers/PaginadorCtrl.js') }}
  {{ HTML::script('js/controllers/ModalAlertaCtrl.js') }}
  {{-- Controlladores genéricos para modales --}}
  {{ HTML::script('js/controllers/ModalDataCtrl.js') }}
  {{ HTML::script('js/controllers/ModalEliminarCtrl.js') }}

</body>
</html>