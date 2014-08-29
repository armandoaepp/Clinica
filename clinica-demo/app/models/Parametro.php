<?php
class Parametro extends Eloquent {
	protected $table = 'parametro';

	protected $timetamps = false;

	protected $nParCodigo;
	protected $nParClase;
	protected $cParJerarquia;
	protected $cParNombre;
	protected $cParDescripcion;
	protected $nParEstado;

	/**
	 * [Búsqueda para un único parámetro]
	 * @return [Parámetro]
	 */
	public static function buscar($nParCodigo, $nParClase) {
		$query = "CALL usp_Buscar_Parametro('$nParCodigo', '$nParClase')";
		return HELPERS::stdArrayToArray(DB::select($query));
	}

	/**
	 * [Búsqueda de parametros por clase]
	 * @return [Arreglo de párametros]
	 */
	public static function buscarPorClase($nParClase) {
		$query = "CALL usp_Get_Parametro_By_cParClase('$nParClase')";
		return HELPERS::stdArrayToArray(DB::select($query));
	}

	/**
	 * [Búsqueda de parametros]
	 * @return [Arreglo de párametros]
	 */
	public static function filtrar($nOriReg, $nCanReg, $nPagRegistro, $nParClase, $cParNombre = "-", $cParDescripcion = "-") {
		$query = "CALL usp_Filtrar_Parametro(
      '$nOriReg',
      '$nCanReg',
      '$nPagRegistro',
      '$nParClase',
      '$cParNombre',
      '$cParDescripcion')";
		return HELPERS::stdArrayToArray(DB::select($query));
	}

	/**
	 * [Registrar un nuevo parámetro]
	 * @return [Objeto creado]
	 */
	public static function registrar($nParClase, $cParNombre, $cParDescripcion) {
		$query = "CALL usp_Set_Parametro('$nParClase', '$cParNombre', '$cParDescripcion')";
		return HELPERS::stdArrayToArray(DB::select($query));
	}

	/**
	 * [Actualizar un parámetro]
	 * @return [Objeto actualizado]
	 */
	public static function actualizar($nParCodigo, $nParClase, $cParNombre, $cParDescripcion) {
		$query = "CALL usp_Upd_Parametro('$nParCodigo', '$nParClase', '$cParNombre', '$cParDescripcion')";
		return HELPERS::stdArrayToArray(DB::select($query));
	}

	/**
	 * [Eliminar parámetro - Solo lo deshabilita cambiándole el estado]
	 * @return [nParCodigo del objeto modificado]
	 */
	public static function eliminar($nParCodigo, $nParClase, $nParEstado) {
		$query = "CALL usp_Upd_Parametro_Estado('$nParCodigo', '$nParClase', '$nParEstado')";
		return HELPERS::stdArrayToArray(DB::select($query));
	}
}
?>