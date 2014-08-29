<?php
/**
 * Métodos globales de ayuda para mi aplicación
 */
class HELPERS {
	public static function getPaginador($nCanPaginas, $paginaActual) {
		$aPaginador = array();

		if ($nCanPaginas > 1) {
			$aBotonInicio = array(
				'pagina'  => 1,
				'texto'   => 'Inicio',
				'inicial' => true,
			);
			array_push($aPaginador, $aBotonInicio);

			for ($i = 0; $i < $nCanPaginas; $i++) {
				$aBotonPaginador = array(
					'pagina' => $i+1,
					'texto'  => $i+1,
				);
				array_push($aPaginador, $aBotonPaginador);
			}

			$aBotonFin = array(
				'pagina' => $nCanPaginas,
				'texto'  => 'Final',
				'final'  => true,
			);
			array_push($aPaginador, $aBotonFin);
		}

		$aPaginador[$paginaActual]['activo'] = true;

		return $aPaginador;
	}

	public static function stdArrayToArray($stdArray) {
		$array = array();

		for ($i = 0; $i < count($stdArray); $i++) {
			$fila = $stdArray[$i];

			foreach ($fila as $property => $value) {
				if (self::isJSON($value)) {
					$array[$i][$property] = json_decode($value);
				} else {
					$array[$i][$property] = $value;
				}
			}
		}

		return $array;
	}

	public static function isJSON($string) {
		$validacion = false;

		if (is_string($string)) {
			$validacion = is_object(json_decode($string));
		}

		return $validacion;
	}
}
?>