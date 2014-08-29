<?php

/*
|--------------------------------------------------------------------------
| Application Routes
|--------------------------------------------------------------------------
|
| Here is where you can register all of the routes for an application.
| It's a breeze. Simply tell Laravel the URIs it should respond to
| and give it the Closure to execute when that URI is requested.
|
 */

Route::get('/', 'InicioController@showInicio');

Route::get('/tablas-maestras/colors', array(
		'as'   => 'colors',
		'uses' => 'ColorController@jsonInicio',
	));

Route::post('/tablas-maestras/colors/filtrar', array(
		'as'   => 'colorsFiltrar',
		'uses' => 'ColorController@jsonFiltrar',
	));

Route::match(array('GET', 'POST'), '/tablas-maestras/colors/agregar', array(
		'as'   => 'colorsAgregar',
		'uses' => 'ColorController@jsonAgregar',
	));

Route::match(array('GET', 'POST'), '/tablas-maestras/colors/editar/{nParCodigo}/{nParClase}', array(
		'as'   => 'colorsEditar',
		'uses' => 'ColorController@jsonEditar',
	));

Route::get('/tablas-maestras/colors/eliminar/{nParCodigo}/{nParClase}', array(
		'as'   => 'colorsEliminar',
		'uses' => 'ColorController@jsonEliminar',
	));
