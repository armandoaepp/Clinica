<?php

class ColorController extends BaseController {
	private $nParClase = 1010;
	private $nCanReg   = 10;

	/**
	 * [Busca y envía los datos de la vista en formato json]
	 * @return [json] [Todos los datos de la vista]
	 */
	public function jsonInicio() {
		// Botonera
		$dbBotonera = DB::select('CALL usp_Get_Permisos_Botonera_By_Usuario(1, 0, 0, 0, 1001, 1, 1001, 1, 1000, 100101);');

		$dataBotonera = array();

		for ($i = 0; $i < count($dbBotonera); $i++) {
			$fila = $dbBotonera[$i];

			foreach ($fila as $property => $value) {
				if (HELPERS::isJSON($value)) {
					$dataBotonera[$i][$property] = json_decode($value);
				} else {
					$dataBotonera[$i][$property] = $value;
				}
			}
		}

		// Registros
		$nOriReg         = 0;
		$nCanReg         = $this->nCanReg;
		$nPagRegistro    = 1;
		$nParClase       = $this->nParClase;
		$cParNombre      = "";
		$cParDescripcion = "";

		$dataRegistros = Parametro::filtrar($nOriReg, $nCanReg, $nPagRegistro, $nParClase, $cParNombre, $cParDescripcion);
		$dataRegistros = $this->completarRegistros($dataRegistros, 1);

		// Total de registros
		$dataTodosRegistros = Parametro::buscarPorClase($this->nParClase);
		$totalRegistros     = count($dataTodosRegistros);
		$nCanPaginas        = ceil($totalRegistros/$this->nCanReg);

		// Paginador
		$dataPaginador = HELPERS::getPaginador($nCanPaginas, 1);

		// Rutas
		$dataRutas = array(
			'agregar' => URL::route('colorsAgregar'),
			'editar'  => array(
				'url' => URL::route('colorsEditar', array(
						'nParCodigo' => '-p-nParCodigo',
						'nParClase'  => '-p-nParClase',
					)
				),
				'parametros' => array('nParCodigo', 'nParClase'),
			),
			'eliminar' => array(
				'url' => URL::route('colorsEliminar', array(
						'nParCodigo' => '-p-nParCodigo',
						'nParClase'  => '-p-nParClase',
					)
				),
				'parametros' => array('nParCodigo', 'nParClase'),
			),
			'filtrar' => URL::route('colorsFiltrar'),
		);

		$data = array(
			'dataBotonera'   => $dataBotonera,
			'dataRegistros'  => $dataRegistros,
			'dataPaginador'  => $dataPaginador,
			'dataRutas'      => $dataRutas,
			'totalRegistros' => $totalRegistros,
		);

		return json_encode($data);
	}

	/**
	 * [Busca los y envía los registros]
	 * @return [json] [Registros en formato json]
	 */
	public function jsonFiltrar() {
		$pagina          = Input::get('pagina');
		$cParNombre      = Input::get('camposBusqueda.cParNombre');
		$cParDescripcion = Input::get('camposBusqueda.cParDescripcion');

		$pagina          = ($pagina === null)?'':$pagina;
		$cParNombre      = ($cParNombre === null)?'':$cParNombre;
		$cParDescripcion = ($cParDescripcion === null)?'':$cParDescripcion;

		// Registros
		$nCanReg      = $this->nCanReg;
		$nOriReg      = ($pagina-1)*$nCanReg;
		$nPagRegistro = 1;
		$nParClase    = $this->nParClase;

		$dataRegistros = Parametro::filtrar($nOriReg, $nCanReg, $nPagRegistro, $nParClase, $cParNombre, $cParDescripcion);
		$dataRegistros = $this->completarRegistros($dataRegistros, $pagina);

		// Total de registros
		$nPagRegistro   = 0;
		$totalRegistros = count(Parametro::filtrar($nOriReg, $nCanReg, $nPagRegistro, $nParClase, $cParNombre, $cParDescripcion));
		$nCanPaginas    = ceil($totalRegistros/$nCanReg);

		// Paginador
		$dataPaginador = HELPERS::getPaginador($nCanPaginas, $pagina);

		$data = array(
			'dataRegistros'  => $dataRegistros,
			'dataPaginador'  => $dataPaginador,
			'totalRegistros' => $totalRegistros,
		);

		return json_encode($data);
	}

	/**
	 * [Guardo un nuevo registro]
	 * @return [json] [Respuesta en formato json]
	 */
	public function jsonAgregar() {
		if (Request::isMethod('get')) {
			$dataFormulario = array(
				'metodo' => 'POST',
				'accion' => array(
					'agregar'  => URL::route('colorsAgregar'),
					'editar'   => URL::route('colorsEditar'),
					'eliminar' => URL::route('colorsEliminar'),
				),
				'campos' => array(
					array(
						'name'        => 'cParDescripcion',
						'value'       => '',
						'label'       => 'Nombre',
						'formType'    => 'text',
						'placeholder' => 'Nombre',
					),
				),
			);

			$data = array(
				'dataFormulario' => $dataFormulario,
			);

			return json_encode($data);

		} elseif (Request::isMethod('post')) {

			$nParClase       = $this->nParClase;
			$cParNombre      = Input::get('cParDescripcion');
			$cParDescripcion = Input::get('cParDescripcion');

			$newParametro = Parametro::registrar($nParClase, $cParNombre, $cParDescripcion);

			// Registros
			$nOriReg         = 0;
			$nCanReg         = $this->nCanReg;
			$nPagRegistro    = 1;
			$nParClase       = $this->nParClase;
			$cParNombre      = "";
			$cParDescripcion = "";

			$dataRegistros = Parametro::filtrar($nOriReg, $nCanReg, $nPagRegistro, $nParClase, $cParNombre, $cParDescripcion);
			$dataRegistros = $this->completarRegistros($dataRegistros, 1);

			// Total de registros
			$dataTodosRegistros = Parametro::buscarPorClase($this->nParClase);
			$totalRegistros     = count($dataTodosRegistros);
			$nCanPaginas        = ceil($totalRegistros/$this->nCanReg);

			// Paginador
			$dataPaginador = HELPERS::getPaginador($nCanPaginas, 1);

			$data = array(
				'dataRegistros'  => $dataRegistros,
				'dataPaginador'  => $dataPaginador,
				'totalRegistros' => $totalRegistros,
			);

			return json_encode($data);
		}

	}

	public function jsonEditar($nParCodigo, $nParClase) {
		if (Request::isMethod('get')) {
			$parametro = Parametro::buscar($nParCodigo, $nParClase);

			if ($parametro) {
				$parametro = reset($parametro);

				$dataFormulario = array(
					'metodo' => 'POST',
					'accion' => URL::route('colorsEditar'),
					'campos' => array(
						array(
							'name'        => 'cParDescripcion',
							'value'       => $parametro['cParDescripcion'],
							'label'       => 'Nombre',
							'formType'    => 'text',
							'placeholder' => 'Nombre',
						),
					),
				);

				$data = array(
					'dataFormulario' => $dataFormulario,
				);

				return json_encode($data);
			}

		} elseif (Request::isMethod('post')) {
			$cParNombre      = Input::get('cParNombre');
			$cParDescripcion = Input::get('cParDescripcion');

			$updParametro = Parametro::actualizar($nParCodigo, $nParClase, $cParNombre, $cParDescripcion);

			// Registros
			$nOriReg         = 0;
			$nCanReg         = $this->nCanReg;
			$nPagRegistro    = 1;
			$nParClase       = $this->nParClase;
			$cParNombre      = "";
			$cParDescripcion = "";

			$dataRegistros = Parametro::filtrar($nOriReg, $nCanReg, $nPagRegistro, $nParClase, $cParNombre, $cParDescripcion);
			$dataRegistros = $this->completarRegistros($dataRegistros, 1);

			$data = array(
				'dataRegistros' => $dataRegistros,
			);

			return json_encode($data);
		}

	}

	public function jsonEliminar($nParCodigo, $nParClase) {
		$nParEstado = 0;

		$updnParCodigo = Parametro::eliminar($nParCodigo, $nParClase, $nParEstado);

		// Registros
		$nOriReg         = 0;
		$nCanReg         = $this->nCanReg;
		$nPagRegistro    = 1;
		$nParClase       = $this->nParClase;
		$cParNombre      = "";
		$cParDescripcion = "";

		$dataRegistros = Parametro::filtrar($nOriReg, $nCanReg, $nPagRegistro, $nParClase, $cParNombre, $cParDescripcion);
		$dataRegistros = $this->completarRegistros($dataRegistros, 1);

		// Total de registros
		$dataTodosRegistros = Parametro::buscarPorClase($this->nParClase);
		$totalRegistros     = count($dataTodosRegistros);
		$nCanPaginas        = ceil($totalRegistros/$this->nCanReg);

		// Paginador
		$dataPaginador = HELPERS::getPaginador($nCanPaginas, 1);

		$data = array(
			'dataRegistros'  => $dataRegistros,
			'dataPaginador'  => $dataPaginador,
			'totalRegistros' => $totalRegistros,
		);

		return json_encode($data);
	}

	/////////////////////////////////////////////////////
	// ---------------MÉTODOS INTERNOS--------------- //
	/////////////////////////////////////////////////////

	private function completarRegistros($dataRegistros, $pagina) {
		for ($i = 0; $i < count($dataRegistros); $i++) {
			$dataRegistros[$i]['index']     = ($this->nCanReg*($pagina-1))+$i+1;
			$dataRegistros[$i]['nParClase'] = $this->nParClase;
			$dataRegistros[$i]['formData']  = array(
				'cParDescripcion' => $dataRegistros[$i]['cParDescripcion'],
				'camposOcultos'   => array(
					'nParCodigo' => array(
						'name'  => 'nParCodigo',
						'value' => $dataRegistros[$i]['nParCodigo'],
					),
					'nParClase' => array(
						'name'  => 'nParClase',
						'value' => $this->nParClase,
					),
				),
			);
		}

		return $dataRegistros;
	}
}
?>