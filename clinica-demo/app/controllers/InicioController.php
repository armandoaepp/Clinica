<?php

class InicioController extends BaseController {
	function showInicio() {
		$dataMenu = DB::select('Call usp_Get_Permisos_By_Usuario(1, 0, 0, 0, 1000, 1, 10);');

		$aMenus = array();

		foreach ($dataMenu as $key => $objFila) {
			$codigo   = $objFila->nPerUsuAccCodigo;
			$objPadre = $this->buscarPadre($dataMenu, $objFila);

			if ($objPadre) {
				$aMenus = $this->setHijoRecursivo($objFila, $objPadre->nPerUsuAccCodigo, $aMenus);
			} else {
				$aMenus[$codigo]['objeto'] = $objFila;
			}
		}

		$aMenus = $this->jsonStringToArray($aMenus);

		return View::make('inicio', array(
				'jsonMenus' => json_encode($aMenus),
			));
	}

	private function buscarPadre($array, $filaHijo) {
		$downCod = (string) $filaHijo->nPerUsuAccCodigo;

		foreach ($array as $key => $aFila) {
			$upCod = (string) $aFila->nPerUsuAccCodigo;

			if ($downCod != $upCod) {
				$condicion = (strpos($downCod, $upCod) || (strpos($downCod, $upCod) === 0)) && ((int) $filaHijo->CanJerarquia == (int) ($aFila->CanJerarquia+2));
				if ($condicion) {
					return $aFila;
				}
			}
		}

		return false;
	}

	private function setHijoRecursivo($filaHijo, $codPadre, $arreglo) {
		$codHijo = $filaHijo->nPerUsuAccCodigo;

		$comparation = array_key_exists($codPadre, $arreglo) && $codHijo != $codPadre;

		if ($comparation) {
			$arreglo[$codPadre]['subMenus'][$codHijo]['objeto'] = $filaHijo;
			return $arreglo;

		} else {
			foreach ($arreglo as $key => $item) {
				if (isset($item['subMenus'])) {
					if (count($item['subMenus']) > 0) {
						$item['subMenus'] = $this->setHijoRecursivo($filaHijo, $codPadre, $item['subMenus']);
						$arreglo[$key]    = $item;
						return $arreglo;
					}
				}
			}
		}

		return $arreglo;
	}

	private function jsonStringToArray($data) {
		foreach ($data as $key => $value) {
			if (is_array($data)) {
				if (is_array($data[$key]) || is_object($data[$key])) {
					$data[$key] = $this->jsonStringToArray($data[$key]);
				} else {
					if (HELPERS::isJSON($data[$key])) {
						$data[$key] = json_decode($data[$key]);
					}
				}
			}
			if (is_object($data)) {
				if (is_array($data->$key) || is_object($data->$key)) {
					$data->$key = $this->jsonStringToArray($data->$key);
				} else {
					if (HELPERS::isJSON($data->$key)) {
						$data->$key = json_decode($data->$key);
					}
				}
			}
		}

		return $data;
	}
}
?>
