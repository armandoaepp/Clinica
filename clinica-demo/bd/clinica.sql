-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Servidor: localhost
-- Tiempo de generación: 15-08-2014 a las 12:35:55
-- Versión del servidor: 5.5.38-0ubuntu0.14.04.1
-- Versión de PHP: 5.5.9-1ubuntu4.3

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de datos: `clinica`
--

DELIMITER $$
--
-- Procedimientos
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_Filtrar_Parametro`(nOriReg Int(4), nCanReg Int(4), nPagRegistro Int(4) , nParClase int(11) , cParNombre varchar(100), cParDescripcion varchar(500))
BEGIN

	IF  (nPagRegistro = 1 ) THEN
		SET @sentencia = CONCAT('SELECT parametro.nParCodigo,
							parametro.cParNombre,
							IFNULL(parametro.cParDescripcion,"") cParDescripcion
					FROM parametro
					WHERE parametro.nParClase="',nParClase,'"
					AND parametro.nParEstado = 1
					AND( ( "',cParNombre ,'" 				= "-" )	OR ( parametro.cParNombre like "',cParNombre ,'%") )
					AND( ( "',cParDescripcion ,'" 	= "-" ) OR ( parametro.cParDescripcion like "',cParDescripcion ,'%") )
					ORDER BY parametro.cParDescripcion ASC
					LIMIT  ',nOriReg,',',nCanReg,' ; ');
					prepare consulta FROM @sentencia;
					execute consulta;
	ELSE
		SELECT parametro.nParCodigo,
				parametro.cParNombre,
				IFNULL(parametro.cParDescripcion,"") cParDescripcion
		FROM parametro
		WHERE parametro.nParClase = nParClase
		AND parametro.nParEstado = 1
		AND ( ( cParNombre 			= "-" ) OR ( parametro.cParNombre 			LIKE CONCAT(cParNombre,'%') ) )
		AND	( ( cParDescripcion = "-" ) OR ( parametro.cParDescripcion 	LIKE CONCAT(cParDescripcion,'%') ) )
		ORDER BY parametro.cParDescripcion ASC ;
	END IF;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_Get_Parametro_By_cParClase`(nParClase int(11))
BEGIN
		SELECT parametro.nParCodigo,
				parametro.cParNombre,
				parametro.cParDescripcion
		FROM parametro
		WHERE parametro.nParEstado = 1
		AND parametro.nParClase = nParClase
		ORDER BY 	parametro.cParDescripcion ,
		parametro.cParNombre  ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_Get_Permisos_Botonera_By_Usuario`(nPerTipo int(4), nPerEstado int(4), nPerUsuEstado Int(4), nPerUsuAccEstado Int(4), nParClase Int(4),cPerCodigo  varchar(20), nPerUsuAccGrupo Int(4), nParTipo Int(4), nParSrcClase Int(4), nParSrcCodigo Int(4))
BEGIN
	SELECT persona.cPerCodigo,
		persona.cPerNombre,
		persona.nPerTipo,
		perusuacceso.nPerUsuAccGrupo,
    perusuacceso.nPerUsuAccCodigo,
		perusuacceso.nPerUsuAccEstado,
		parametro.cParJerarquia,
		parametro.cParNombre,
    parametro.cParDescripcion,
		(length(parametro.cParJerarquia)) as CanJerarquia,
		parparametro.cValor
	FROM persona
  INNER JOIN perusuario  	ON persona.cPerCodigo    = perusuario.cPerCodigo
  INNER JOIN perusuacceso ON perusuario.cPerCodigo = perusuacceso.cPerCodigo
  INNER JOIN parametro    ON parametro.nParCodigo  = perusuacceso.nPerUsuAccCodigo AND parametro.nParClase = perusuacceso.nPerUsuAccObjCodigo
	INNER JOIN parparametro	ON parparametro.nParDstClase = parametro.nParClase AND parparametro.nParDstCodigo = parametro.nParCodigo
	WHERE persona.nPerTipo             = nPerTipo
  AND persona.nPerEstado             <> nPerEstado
  AND perusuario.nPerUsuEstado       <> nPerUsuEstado
  AND perusuacceso.nPerUsuAccEstado  <>	nPerUsuAccEstado
  AND parametro.nParClase            = nParClase
  AND persona.cPerCodigo             = cPerCodigo
	AND perusuacceso.nPerUsuAccGrupo	 = nPerUsuAccGrupo
	AND parametro.nParEstado			   		 = nParTipo
	AND parparametro.nParSrcClase			 = nParSrcClase
	AND parparametro.nParSrcCodigo		 = nParSrcCodigo
	ORDER BY parametro.cParJerarquia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_Get_Permisos_By_Usuario`(nPerTipo int(4), nPerEstado int(4), nPerUsuEstado Int(4), nPerUsuAccEstado Int(4), nParClase Int(4), cPerCodigo  varchar(20), nPerUsuAccGrupo Int(4))
BEGIN
	SELECT persona.cPerCodigo,
		persona.cPerNombre,
		persona.nPerTipo,
		perusuacceso.nPerUsuAccGrupo,
    perusuacceso.nPerUsuAccCodigo,
		perusuacceso.nPerUsuAccEstado,
		parametro.cParJerarquia,
		parametro.cParNombre,
    Concat(left(parametro.cParDescripcion,1),lower(right(parametro.cParDescripcion,(length(parametro.cParDescripcion)-1)))) AS NombreMenu,
		(length(parametro.cParJerarquia)) as CanJerarquia
	FROM persona
  INNER JOIN perusuario   ON persona.cPerCodigo    = perusuario.cPerCodigo
  INNER JOIN perusuacceso ON perusuario.cPerCodigo = perusuacceso.cPerCodigo
  INNER JOIN parametro    ON parametro.nParCodigo  = perusuacceso.nPerUsuAccCodigo AND parametro.nParClase = perusuacceso.nPerUsuAccObjCodigo
	WHERE persona.nPerTipo            = nPerTipo
  AND persona.nPerEstado            <> nPerEstado
  AND perusuario.nPerUsuEstado      <> nPerUsuEstado
  AND perusuacceso.nPerUsuAccEstado <> nPerUsuAccEstado
  AND parametro.nParClase           = nParClase
  AND persona.cPerCodigo            = cPerCodigo
	AND perusuacceso.nPerUsuAccGrupo	= nPerUsuAccGrupo
	ORDER BY parametro.cParJerarquia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_Set_Parametro`(nParClase int(11) ,cParNombre varchar(100), cParDescripcion varchar(500))
BEGIN
  DECLARE nParCodigo INT;
	DECLARE cParJerarquia VARCHAR(20);
-- Generar codigo para el parametro
  SELECT 	IFNULL( MAX(parametro.nParCodigo)+1 , 1 ) INTO nParCodigo
	FROM		parametro
	WHERE		parametro.nParClase = nParClase;
-- Generar jerarquia para el parametro
  -- SELECT 	LPAD(IFNULL( MAX(parametro.cParJerarquia)+1 , 1001 ),4,'0') INTO cParJerarquia
	SELECT 	IFNULL( MAX(parametro.cParJerarquia)+1 , 1001 ) INTO cParJerarquia
	FROM 		parametro
	WHERE 	parametro.nParClase=nParClase AND parametro.nParCodigo <> 0 ;

		INSERT INTO parametro (parametro.nParCodigo,
												 parametro.nParClase,
												 parametro.cParJerarquia,
												 parametro.cParNombre,
												 parametro.cParDescripcion,
												 parametro.nParEstado)
  VALUES(nParCodigo, nParClase, cParJerarquia, cParNombre, cParDescripcion,	1);

	SELECT nParCodigo, cParJerarquia;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_Upd_Parametro`(nParCodigo int(11), nParClase  int(11) , cParNombre varchar(100), cParDescripcion varchar(255))
BEGIN

		UPDATE parametro
			SET parametro.cParNombre = cParNombre,
					parametro.cParDescripcion = cParDescripcion
		WHERE parametro.nParCodigo = nParCodigo
		AND parametro.nParClase = nParClase
		AND parametro.nParEstado = 1;

	SELECT  nParCodigo  ;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `usp_Upd_Parametro_Estado`(nParCodigo int(11), nParClase int(11) ,   nParEstado int(3))
BEGIN
  UPDATE parametro SET
				parametro.nParEstado = nParEstado
	WHERE parametro.nParCodigo = nParCodigo
	AND parametro.nParClase = nParClase ;

SELECT nParCodigo  ;

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `bieregdocumento`
--

CREATE TABLE IF NOT EXISTS `bieregdocumento` (
  `nBieRegCodigo` int(11) NOT NULL,
  `cDocCodigo` varchar(100) NOT NULL,
  `nBieRegDocEstado` int(11) NOT NULL,
  PRIMARY KEY (`nBieRegCodigo`,`cDocCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docbieregdistribucion`
--

CREATE TABLE IF NOT EXISTS `docbieregdistribucion` (
  `cDocCodigo` varchar(20) NOT NULL,
  `estado` int(11) DEFAULT NULL,
  `nAlmOrigen` int(11) NOT NULL,
  `nAlmDestino` int(11) NOT NULL,
  `nBieRegCodigo` int(11) NOT NULL,
  `observacion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`cDocCodigo`,`nBieRegCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docbieregistro`
--

CREATE TABLE IF NOT EXISTS `docbieregistro` (
  `cDocCodigo` varchar(15) CHARACTER SET latin1 NOT NULL,
  `nNroItem` int(11) NOT NULL,
  `nBieRegCodigo` int(11) NOT NULL,
  `nEstado` int(11) NOT NULL,
  PRIMARY KEY (`cDocCodigo`,`nNroItem`,`nBieRegCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `doccompdetvalor`
--

CREATE TABLE IF NOT EXISTS `doccompdetvalor` (
  `cDocCodigo` varchar(15) CHARACTER SET latin1 NOT NULL,
  `nNroItem` int(11) NOT NULL,
  `nMoneda` int(11) NOT NULL,
  `fValor` double(11,2) NOT NULL,
  `fDescuento` double(11,2) DEFAULT NULL,
  `fIGV` double(11,2) DEFAULT NULL,
  `dGravado` date DEFAULT NULL,
  PRIMARY KEY (`cDocCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `doccomprobante`
--

CREATE TABLE IF NOT EXISTS `doccomprobante` (
  `cDocCodigo` varchar(15) CHARACTER SET latin1 NOT NULL,
  `nTipo` int(11) NOT NULL,
  `nMoneda` int(11) NOT NULL,
  `fmonto` float(11,0) NOT NULL,
  PRIMARY KEY (`cDocCodigo`,`nTipo`,`nMoneda`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `doccontenido`
--

CREATE TABLE IF NOT EXISTS `doccontenido` (
  `cDocCodigo` varchar(15) NOT NULL,
  `nDocParCodigo` int(11) NOT NULL,
  `nDocParClase` int(11) NOT NULL,
  `cDocConContenido` text NOT NULL,
  `nDocConEstado` int(11) NOT NULL,
  PRIMARY KEY (`cDocCodigo`,`nDocParCodigo`,`nDocParClase`),
  UNIQUE KEY `idx_pk` (`cDocCodigo`,`nDocParClase`,`nDocParCodigo`) USING BTREE,
  UNIQUE KEY `nDocParCodigo_UNIQUE` (`nDocParCodigo`) USING BTREE,
  UNIQUE KEY `nDocParClase_UNIQUE` (`nDocParClase`) USING BTREE,
  KEY `idx_clase_codigo` (`nDocParClase`,`nDocParCodigo`) USING BTREE,
  KEY `idx_cdoccodigo` (`cDocCodigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docestado`
--

CREATE TABLE IF NOT EXISTS `docestado` (
  `cDocCodigo` varchar(15) NOT NULL,
  `nDocParCodigo` int(11) unsigned NOT NULL,
  `nDocParClase` int(11) unsigned NOT NULL,
  `dDocEstFecha` datetime NOT NULL,
  `cDocEstGlosa` text,
  PRIMARY KEY (`cDocCodigo`,`nDocParCodigo`,`nDocParClase`,`dDocEstFecha`),
  UNIQUE KEY `idx_pk` (`cDocCodigo`,`nDocParClase`,`nDocParCodigo`,`dDocEstFecha`) USING BTREE,
  KEY `idx_cdoccodigo` (`cDocCodigo`) USING BTREE,
  KEY `idex_clase_codigo` (`nDocParClase`,`nDocParCodigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docidentifica`
--

CREATE TABLE IF NOT EXISTS `docidentifica` (
  `cDocCodigo` varchar(15) NOT NULL,
  `nDocTipoNum` int(11) NOT NULL,
  `cDocNDoc` varchar(100) NOT NULL,
  PRIMARY KEY (`cDocCodigo`,`nDocTipoNum`),
  UNIQUE KEY `idx_pk` (`cDocCodigo`,`nDocTipoNum`) USING BTREE,
  KEY `idx_cdocndoc` (`cDocNDoc`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docparametro`
--

CREATE TABLE IF NOT EXISTS `docparametro` (
  `cDocCodigo` varchar(15) NOT NULL,
  `nParClase` int(11) unsigned NOT NULL,
  `nParCodigo` int(11) unsigned NOT NULL,
  `cDocParObservacion` varchar(500) NOT NULL,
  PRIMARY KEY (`cDocCodigo`,`nParClase`,`nParCodigo`),
  UNIQUE KEY `idx_pk` (`cDocCodigo`,`nParClase`,`nParCodigo`) USING BTREE,
  UNIQUE KEY `cDocCodigo_UNIQUE` (`cDocCodigo`) USING BTREE,
  KEY `idx_cdoccodigo` (`cDocCodigo`) USING BTREE,
  KEY `idx_clase_codigo` (`nParClase`,`nParCodigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docparparametro`
--

CREATE TABLE IF NOT EXISTS `docparparametro` (
  `cDocCodigo` varchar(20) CHARACTER SET latin1 NOT NULL,
  `nParSrcCodigo` int(11) NOT NULL,
  `nParSrcClase` int(11) NOT NULL,
  `nParDstCodigo` int(11) NOT NULL,
  `nParDstClase` int(11) NOT NULL,
  `cParParValor` varchar(250) CHARACTER SET latin1 DEFAULT NULL,
  `cParParGlosa` text CHARACTER SET latin1,
  PRIMARY KEY (`cDocCodigo`,`nParSrcCodigo`,`nParSrcClase`,`nParDstCodigo`,`nParDstClase`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docperparametro`
--

CREATE TABLE IF NOT EXISTS `docperparametro` (
  `cDocCodigo` varchar(20) NOT NULL,
  `cPerCodigo` varchar(20) NOT NULL,
  `nParCodigo` int(11) NOT NULL,
  `nParClase` int(11) NOT NULL,
  `cDocPerParValor` varchar(500) DEFAULT NULL,
  `cDocPerParGlosa` text,
  `nDocPerParEstado` int(4) NOT NULL,
  PRIMARY KEY (`cDocCodigo`,`cPerCodigo`,`nParCodigo`,`nParClase`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docpersona`
--

CREATE TABLE IF NOT EXISTS `docpersona` (
  `cDocCodigo` varchar(15) NOT NULL,
  `nDocPerTipo` int(11) NOT NULL,
  `cPerCodigo` varchar(20) NOT NULL,
  `nPerRelacion` int(11) NOT NULL,
  `nDocTipo` int(11) NOT NULL,
  PRIMARY KEY (`cDocCodigo`,`nDocPerTipo`,`cPerCodigo`,`nPerRelacion`,`nDocTipo`),
  UNIQUE KEY `id_pk` (`cDocCodigo`,`nDocPerTipo`,`cPerCodigo`,`nPerRelacion`,`nDocTipo`) USING BTREE,
  KEY `idx_cdoccodigo` (`cDocCodigo`) USING BTREE,
  KEY `idx_cpercodigo` (`cPerCodigo`) USING BTREE,
  KEY `idx_cdoc_ndoc_cper` (`cDocCodigo`,`nDocPerTipo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docref`
--

CREATE TABLE IF NOT EXISTS `docref` (
  `cDocCodigo` varchar(15) NOT NULL DEFAULT '',
  `cDocRefCodigo` varchar(15) NOT NULL,
  PRIMARY KEY (`cDocCodigo`,`cDocRefCodigo`),
  UNIQUE KEY `idx_pk` (`cDocCodigo`,`cDocRefCodigo`) USING BTREE,
  KEY `idx_cdoccodigo` (`cDocCodigo`) USING BTREE,
  KEY `idx_cdocrefcodigo` (`cDocRefCodigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docrefdestino`
--

CREATE TABLE IF NOT EXISTS `docrefdestino` (
  `cDocCodigo` varchar(15) CHARACTER SET latin1 NOT NULL,
  `cLugarOrigen` text CHARACTER SET latin1 NOT NULL,
  `nOrigTipo` int(11) NOT NULL,
  `cOrigDireccion` varchar(200) CHARACTER SET latin1 NOT NULL,
  `cOrigManz` varchar(100) CHARACTER SET latin1 NOT NULL,
  `cOrigLote` varchar(100) CHARACTER SET latin1 NOT NULL,
  `nOrigTipoRes` int(11) NOT NULL,
  `cOrigResidencia` varchar(200) CHARACTER SET latin1 NOT NULL,
  `cLugarDestino` text CHARACTER SET latin1 NOT NULL,
  `nDestTipo` int(11) NOT NULL,
  `cDestDireccion` varchar(200) CHARACTER SET latin1 NOT NULL,
  PRIMARY KEY (`cDocCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `documento`
--

CREATE TABLE IF NOT EXISTS `documento` (
  `cDocCodigo` varchar(15) NOT NULL,
  `dDocFecha` datetime NOT NULL,
  `cDocObservacion` varchar(1000) NOT NULL,
  `nDocTipo` int(11) NOT NULL,
  `nDocEstado` tinyint(3) NOT NULL,
  PRIMARY KEY (`cDocCodigo`),
  UNIQUE KEY `idx_cdoccodigo` (`cDocCodigo`) USING BTREE,
  KEY `idx_cdoccodigo_ndoctipo` (`cDocCodigo`,`nDocTipo`) USING BTREE,
  KEY `idx_nDocTipo` (`nDocTipo`) USING BTREE,
  KEY `idx_nEstado` (`nDocEstado`,`cDocCodigo`,`nDocTipo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `docvigencia`
--

CREATE TABLE IF NOT EXISTS `docvigencia` (
  `cDocCodigo` varchar(15) NOT NULL,
  `dFecha` date NOT NULL,
  `dFechaFin` date NOT NULL,
  `dHora` datetime NOT NULL,
  PRIMARY KEY (`cDocCodigo`),
  UNIQUE KEY `Codigo` (`cDocCodigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parametro`
--

CREATE TABLE IF NOT EXISTS `parametro` (
  `nParCodigo` int(11) unsigned NOT NULL,
  `nParClase` int(11) NOT NULL,
  `cParJerarquia` varchar(20) NOT NULL,
  `cParNombre` varchar(100) NOT NULL,
  `cParDescripcion` varchar(500) NOT NULL,
  `nParEstado` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`nParClase`,`nParCodigo`),
  UNIQUE KEY `idx_pk_parametro` (`nParCodigo`,`nParClase`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `parametro`
--

INSERT INTO `parametro` (`nParCodigo`, `nParClase`, `cParJerarquia`, `cParNombre`, `cParDescripcion`, `nParEstado`) VALUES
(10, 1000, '10', 'MODULO SISTEMA WEB', 'MODULO SISTEMA WEB', 0),
(1001, 1000, '1001', '{"icono":{"bsClase":"glyphicon glyphicon-th-list","color":"cl-verde"}}', 'Tablas maestras', 0),
(1002, 1000, '1002', '{"icono":{"bsClase":"glyphicon glyphicon-cog","color":"cl-amarillo"}}', 'Menu 2', 0),
(100101, 1000, '100101', '{"nParClase":"1010","nombreRuta":"colors"}', 'Colores', 0),
(100201, 1000, '100201', '', 'Submenu 2', 0),
(10010101, 1001, '10010101', '{"nombre":"Agregar","clase":"agregar","icono":"glyphicon glyphicon-plus-sign"}', 'Nuevo', 10),
(10010102, 1001, '10010102', '{"nombre":"Editar","clase":"editar","icono":"glyphicon glyphicon-edit"}', 'Editar', 10),
(10010103, 1001, '10010103', '{"nombre":"Eliminar","clase":"eliminar","icono":"glyphicon glyphicon-trash"}', 'Eliminar', 10),
(0, 1010, '10', 'COLOR', '.::COLOR::.', 0),
(1, 1010, '1001', 'Nombre 1', 'Descripcion 1', 1),
(2, 1010, '1002', 'Nombre 2', 'Descripcion 2', 1),
(3, 1010, '1003', 'Nombre 3', 'Descripcion 3', 1),
(4, 1010, '1004', 'Nombre 4', 'Descripcion 4', 1),
(5, 1010, '1005', 'Nombre 5', 'Descripcion 5', 1),
(6, 1010, '1006', 'Nombre 6', 'Descripcion 6', 1),
(7, 1010, '1007', 'Nombre 7', 'Descripcion 7', 1),
(8, 1010, '1008', 'Nombre 8', 'Descripcion 8', 1),
(9, 1010, '1009', 'Nombre 9', 'Descripcion 9', 1),
(10, 1010, '1010', 'Nombre 10', 'Descripcion 10', 1),
(11, 1010, '1011', 'Nombre 11', 'Descripcion 11', 1),
(12, 1010, '1012', 'Nombre 12', 'Descripcion 12', 1),
(13, 1010, '1013', 'Nombre 13', 'Descripcion 13', 1),
(14, 1010, '1014', 'Nombre 14', 'Descripcion 14', 1),
(15, 1010, '1015', 'Nombre 15', 'Descripcion 15', 1),
(16, 1010, '1016', 'Nombre 16', 'Descripcion 16', 1),
(17, 1010, '1017', 'Nombre 17', 'Descripcion 17', 1),
(18, 1010, '1018', 'Nombre 18', 'Descripcion 18', 1),
(19, 1010, '1019', 'Nombre 19', 'Descripcion 19', 1),
(20, 1010, '1020', 'Nombre 20', 'Descripcion 20', 1),
(21, 1010, '1021', 'Nombre 21', 'Descripcion 21', 1),
(22, 1010, '1022', 'Nombre 22', 'Descripcion 22', 1),
(23, 1010, '1023', 'Nombre 23', 'Descripcion 23', 1),
(24, 1010, '1024', 'Nombre 24', 'Descripcion 24', 1),
(25, 1010, '1025', 'Nombre 25', 'Descripcion 25', 1),
(26, 1010, '1026', 'Nombre 26', 'Descripcion 26', 1),
(27, 1010, '1027', 'Nombre 27', 'Descripcion 27', 1),
(28, 1010, '1028', 'Nombre 28', 'Descripcion 28', 1),
(29, 1010, '1029', 'Nombre 29', 'Descripcion 29', 1),
(30, 1010, '1030', 'Nombre 30', 'Descripcion 30', 10),
(31, 1010, '1031', 'Nombre 31', 'Descripcion 31', 10),
(32, 1010, '1032', 'Nombre 32', 'Descripcion 32', 10),
(33, 1010, '1033', 'Nombre 33', 'Descripcion 33', 10),
(34, 1010, '1034', 'Nombre 34', 'Descripcion 34', 10),
(35, 1010, '1035', 'Nombre 35', 'Descripcion 35', 10),
(36, 1010, '1036', 'Nombre 36', 'Descripcion 36', 10),
(37, 1010, '1037', 'Nombre 37', 'Descripcion 37', 10),
(38, 1010, '1038', 'Nombre 38', 'Descripcion 38', 10),
(39, 1010, '1039', 'Nombre 39', 'Descripcion 39', 10),
(40, 1010, '1040', 'Nombre 40', 'Descripcion 40', 10),
(41, 1010, '1041', 'Nombre 41', 'Descripcion 41', 10),
(42, 1010, '1042', 'Nombre 42', 'Descripcion 42', 10),
(43, 1010, '1043', 'Nombre 43', 'Descripcion 43', 10),
(44, 1010, '1044', 'Nombre 44', 'Descripcion 44', 10),
(45, 1010, '1045', 'Nombre 45', 'Descripcion 45', 10),
(46, 1010, '1046', 'Nombre 46', 'Descripcion 46', 10),
(47, 1010, '1047', 'Nombre 47', 'Descripcion 47', 10),
(48, 1010, '1048', 'Nombre 48', 'Descripcion 48', 10),
(49, 1010, '1049', 'Nombre 49', 'Descripcion 49', 10),
(50, 1010, '1050', 'Nombre 50', 'Descripcion 50', 10);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pardetalle`
--

CREATE TABLE IF NOT EXISTS `pardetalle` (
  `nParCodigo` int(11) unsigned NOT NULL,
  `nParClase` int(11) unsigned NOT NULL,
  `nParItem` int(11) unsigned NOT NULL,
  `nParItemS` int(11) unsigned NOT NULL,
  `cParDetValor` varchar(250) CHARACTER SET utf8 NOT NULL,
  `cParDetGlosa` text CHARACTER SET utf8,
  PRIMARY KEY (`nParCodigo`,`nParClase`,`nParItem`,`nParItemS`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parimagen`
--

CREATE TABLE IF NOT EXISTS `parimagen` (
  `nParCodigo` int(11) unsigned NOT NULL,
  `nParClase` int(11) unsigned NOT NULL,
  `nParImgTipo` int(11) unsigned NOT NULL,
  `cParImgRuta` varchar(1000) NOT NULL,
  `cParImgGlosa` text,
  `nParImgEstado` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`nParCodigo`,`nParClase`,`nParImgTipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parparametro`
--

CREATE TABLE IF NOT EXISTS `parparametro` (
  `nParSrcCodigo` int(11) unsigned NOT NULL DEFAULT '0',
  `nParSrcClase` int(11) unsigned NOT NULL,
  `nParDstCodigo` int(11) unsigned NOT NULL,
  `nParDstClase` int(11) unsigned NOT NULL,
  `cValor` varchar(250) DEFAULT NULL,
  `nParParEstado` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`nParSrcCodigo`,`nParSrcClase`,`nParDstCodigo`,`nParDstClase`),
  UNIQUE KEY `idx_pk_all` (`nParSrcCodigo`,`nParSrcClase`,`nParDstCodigo`,`nParDstClase`) USING BTREE,
  KEY `idx_pk_src` (`nParSrcCodigo`,`nParSrcClase`) USING BTREE,
  KEY `idx_pk_dst` (`nParDstCodigo`,`nParDstClase`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `parparametro`
--

INSERT INTO `parparametro` (`nParSrcCodigo`, `nParSrcClase`, `nParDstCodigo`, `nParDstClase`, `cValor`, `nParParEstado`) VALUES
(100101, 1000, 10010101, 1001, 'Nuevo', 1),
(100101, 1000, 10010102, 1001, 'Editar', 1),
(100101, 1000, 10010103, 1001, 'Eliminar', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `parparext`
--

CREATE TABLE IF NOT EXISTS `parparext` (
  `nIntSrcCodigo` int(11) unsigned NOT NULL,
  `nIntSrcClase` int(11) unsigned NOT NULL,
  `nIntDstCodigo` int(11) unsigned NOT NULL,
  `nIntDstClase` int(11) unsigned NOT NULL,
  `nObjCodigo` int(11) unsigned NOT NULL,
  `nObjTipo` int(11) unsigned NOT NULL,
  `cValor` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`nIntSrcCodigo`,`nIntSrcClase`,`nIntDstCodigo`,`nIntDstClase`,`nObjCodigo`,`nObjTipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `percuenta`
--

CREATE TABLE IF NOT EXISTS `percuenta` (
  `nPerCtaCodigo` int(11) NOT NULL AUTO_INCREMENT,
  `cPerCodigo` varchar(20) CHARACTER SET latin1 NOT NULL,
  `cNroCuenta` varchar(20) CHARACTER SET latin1 NOT NULL,
  `nPerCtaTipo` int(11) unsigned NOT NULL,
  `cPerJurCodigo` varchar(20) CHARACTER SET latin1 NOT NULL,
  `nMonCodigo` int(11) unsigned NOT NULL,
  `nPerCtaEstado` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`nPerCtaCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perdireccion`
--

CREATE TABLE IF NOT EXISTS `perdireccion` (
  `cPerCodigo` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'Codigo de la Persona a la que le pertenece esta direccion',
  `nUbiCodigo` int(11) NOT NULL COMMENT 'Codigo del ubigeo de esta direccion',
  `nPerDirTipo` int(11) NOT NULL COMMENT 'Codigo del tipo de la direccion (Casa - trabajo)',
  `cPerDirDescripcion` varchar(500) CHARACTER SET latin1 NOT NULL COMMENT 'Descripcion de la direccion',
  `cPerDirGlosa` varchar(500) CHARACTER SET latin1 DEFAULT NULL,
  `nPerDirEstado` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Se registra la diferentes direcciones de una persona';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perdocumento`
--

CREATE TABLE IF NOT EXISTS `perdocumento` (
  `cPerCodigo` varchar(20) NOT NULL COMMENT 'Codigo de la Persona a la que le pertenece este documento. ',
  `nPerDocTipo` int(11) NOT NULL COMMENT 'Codigo del tipo de documento',
  `cPerDocNumero` varchar(50) NOT NULL COMMENT 'Numero del documento',
  `dPerDocCaducidad` date NOT NULL,
  `nPerDocCategoria` int(11) DEFAULT NULL,
  `nPerDocEstado` tinyint(3) NOT NULL DEFAULT '1',
  PRIMARY KEY (`cPerCodigo`,`nPerDocTipo`,`cPerDocNumero`),
  UNIQUE KEY `idx_pk_PerDocumento` (`cPerCodigo`,`nPerDocTipo`) USING BTREE,
  UNIQUE KEY `idx_cPerDocNumero` (`cPerDocNumero`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Se registra los diferentes documentos de una persona ';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perimagen`
--

CREATE TABLE IF NOT EXISTS `perimagen` (
  `cPerCodigo` varchar(10) NOT NULL,
  `cPerRuta` varchar(50) NOT NULL,
  `nPerTipo` int(11) NOT NULL,
  `nPerEstado` int(11) NOT NULL,
  PRIMARY KEY (`cPerCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perjuridica`
--

CREATE TABLE IF NOT EXISTS `perjuridica` (
  `cPerCodigo` varchar(20) NOT NULL,
  `nPerJurRubro` int(11) NOT NULL,
  `cPerJurDescripcion` varchar(250) NOT NULL,
  `nPerEmpresa` int(11) NOT NULL,
  PRIMARY KEY (`cPerCodigo`),
  UNIQUE KEY `idx_pk_cPerCodigo` (`cPerCodigo`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `permail`
--

CREATE TABLE IF NOT EXISTS `permail` (
  `cPerCodigo` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'Codigo de la Persona a la que le pertenece este Email',
  `nPerMailItem` tinyint(3) NOT NULL COMMENT 'Codigo del tipo de email(personal - corporativo)',
  `cPerMail` varchar(250) NOT NULL COMMENT 'Descripcion del Email',
  `nPerMailEstado` tinyint(3) NOT NULL,
  PRIMARY KEY (`cPerCodigo`,`nPerMailItem`),
  UNIQUE KEY `idx_pk_PerMail` (`cPerCodigo`,`nPerMailItem`) USING BTREE,
  KEY `idx_cPerMail` (`cPerMail`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Se registra los diferentes email de una persona ';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pernatural`
--

CREATE TABLE IF NOT EXISTS `pernatural` (
  `cPerCodigo` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'Codigo de la Persona',
  `cPerNatApePaterno` varchar(250) NOT NULL COMMENT 'Registro del apellido paterno',
  `cPerNatApeMaterno` varchar(250) NOT NULL COMMENT 'Registro del apellido Materno',
  `nPerNatSexo` tinyint(3) unsigned NOT NULL COMMENT 'Codigo de la Persona a la que le pertenece este sexo',
  `nPerNatEstCivil` tinyint(3) unsigned NOT NULL COMMENT 'Codigo de la Persona a la que le pertenece este estado civil',
  PRIMARY KEY (`cPerCodigo`),
  UNIQUE KEY `idx_pk_pernatural` (`cPerCodigo`) USING BTREE,
  KEY `idx_cPerNatApePaterno` (`cPerNatApePaterno`) USING BTREE,
  KEY `idx_cPerNatApeMaterno` (`cPerNatApeMaterno`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='En esta tabla se registra los apellidos de una persona';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perparametro`
--

CREATE TABLE IF NOT EXISTS `perparametro` (
  `cPerCodigo` varchar(20) NOT NULL,
  `nParCodigo` int(11) NOT NULL,
  `nParClase` int(11) NOT NULL,
  `nPerParValor` int(11) DEFAULT NULL,
  `cPerParGlosa` varchar(255) DEFAULT NULL,
  `nPerParEstado` int(4) DEFAULT NULL,
  PRIMARY KEY (`cPerCodigo`,`nParCodigo`,`nParClase`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perrelacion`
--

CREATE TABLE IF NOT EXISTS `perrelacion` (
  `cPerCodigo` varchar(20) CHARACTER SET latin1 NOT NULL,
  `nPerRelTipo` int(11) unsigned NOT NULL,
  `cPerJuridica` varchar(20) CHARACTER SET latin1 NOT NULL,
  `dPerRelacion` date NOT NULL,
  `cPerObservacion` varchar(500) NOT NULL,
  `nPerRelEstado` tinyint(3) unsigned NOT NULL,
  PRIMARY KEY (`cPerCodigo`,`nPerRelTipo`,`cPerJuridica`),
  UNIQUE KEY `idx_pk_PerRelacion` (`cPerCodigo`,`nPerRelTipo`) USING BTREE,
  KEY `idx_cPerJuridica` (`cPerJuridica`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `persona`
--

CREATE TABLE IF NOT EXISTS `persona` (
  `cPerCodigo` varchar(20) NOT NULL COMMENT 'Codigo de la persona.',
  `cPerNombre` varchar(500) NOT NULL COMMENT 'Nombre de la persona.',
  `cPerApellidos` varchar(500) DEFAULT NULL,
  `dPerNacimiento` date NOT NULL COMMENT 'Fecha de nacimiento de la persona.',
  `nPerTipo` tinyint(3) unsigned NOT NULL COMMENT 'Codigo si es una persona  juridica o natural.',
  `nPerEstado` tinyint(3) unsigned NOT NULL COMMENT 'Codigo si esta persona esta activa o inactivo.',
  PRIMARY KEY (`cPerCodigo`),
  UNIQUE KEY `idx_pk_persona` (`cPerCodigo`) USING BTREE,
  KEY `idx_cPerNombre` (`cPerNombre`(255)) USING BTREE,
  KEY `idx_cParApellidos` (`cPerApellidos`(255)) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='En esta tabla se registran los nombres de una persona';

--
-- Volcado de datos para la tabla `persona`
--

INSERT INTO `persona` (`cPerCodigo`, `cPerNombre`, `cPerApellidos`, `dPerNacimiento`, `nPerTipo`, `nPerEstado`) VALUES
('1', 'Andy', 'Diaz Valdiviezo', '1987-02-04', 1, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `pertelefono`
--

CREATE TABLE IF NOT EXISTS `pertelefono` (
  `cPerCodigo` varchar(20) NOT NULL COMMENT 'Codigo de la Persona a la cual le pertenece este Numero Telefonico',
  `nPerTelTipo` int(11) NOT NULL COMMENT 'Tipo de Telefono (Fijo - Celular Movistar - Celular Claro)',
  `nPerTelItem` tinyint(3) unsigned NOT NULL,
  `cPerTelNumero` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'Numero del Telefono',
  `nPerTelEstado` tinyint(3) NOT NULL,
  PRIMARY KEY (`cPerCodigo`,`nPerTelItem`,`nPerTelTipo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Almacena los telefonos de una determinada Persona';

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perusuacceso`
--

CREATE TABLE IF NOT EXISTS `perusuacceso` (
  `cPerCodigo` varchar(20) NOT NULL COMMENT 'Codigo de la persona quien tendra acceso al sistema.',
  `nPerUsuAccGrupo` int(11) unsigned NOT NULL COMMENT 'Codigo de un determinado grupo a la que una persona tendra acceso.',
  `nPerUsuAccTipo` int(11) unsigned NOT NULL COMMENT 'Codigo de un determinado grupo a la que una persona tendra acceso.',
  `nPerUsuAccObjCodigo` int(11) unsigned NOT NULL COMMENT 'Codigo del permiso al que tendra una persona.',
  `nPerUsuAccCodigo` int(11) unsigned NOT NULL COMMENT 'Codigo del permiso al que tendra una persona.',
  `nPerUsuAccPrdCodigo` int(11) unsigned NOT NULL COMMENT 'Codigo de un determinado periodo al que un usuario tendra acceso.',
  `nPerUsuAccEstado` tinyint(3) unsigned NOT NULL COMMENT 'Codigo del estado de un usuario(activo - inactivo).',
  PRIMARY KEY (`cPerCodigo`,`nPerUsuAccGrupo`,`nPerUsuAccTipo`,`nPerUsuAccObjCodigo`,`nPerUsuAccCodigo`,`nPerUsuAccPrdCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='En esta tabla se registraran los permisos de un determinado ';

--
-- Volcado de datos para la tabla `perusuacceso`
--

INSERT INTO `perusuacceso` (`cPerCodigo`, `nPerUsuAccGrupo`, `nPerUsuAccTipo`, `nPerUsuAccObjCodigo`, `nPerUsuAccCodigo`, `nPerUsuAccPrdCodigo`, `nPerUsuAccEstado`) VALUES
('1', 10, 1, 1000, 1001, 0, 1),
('1', 10, 1, 1000, 1002, 0, 1),
('1', 10, 1, 1000, 100101, 0, 1),
('1', 10, 1, 1000, 100201, 0, 1),
('1', 1001, 1, 1001, 10010101, 0, 1),
('1', 1001, 1, 1001, 10010102, 0, 1),
('1', 1001, 1, 1001, 10010103, 0, 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `perusuario`
--

CREATE TABLE IF NOT EXISTS `perusuario` (
  `cPerCodigo` varchar(20) CHARACTER SET latin1 NOT NULL COMMENT 'Codigo de la persona ',
  `cPerUsuCodigo` varchar(50) NOT NULL COMMENT 'Registro del nombre del usuario.',
  `cPerUsuClave` varchar(50) NOT NULL COMMENT 'Registro de la clave del usuario.',
  `nPerUsuEstado` tinyint(3) unsigned NOT NULL COMMENT 'Codigo del estado del usuario(activo - inactivo)',
  PRIMARY KEY (`cPerCodigo`,`cPerUsuCodigo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

--
-- Volcado de datos para la tabla `perusuario`
--

INSERT INTO `perusuario` (`cPerCodigo`, `cPerUsuCodigo`, `cPerUsuClave`, `nPerUsuEstado`) VALUES
('1', 'admin', '21232f297a57a5a743894a0e4a801fc3', 1);

-- --------------------------------------------------------

--
-- Estructura de tabla para la tabla `transaccion`
--

CREATE TABLE IF NOT EXISTS `transaccion` (
  `cTraCodigo` varchar(100) NOT NULL COMMENT 'Codigo de la transaccion que se va a realizar.',
  `nOpeCodigo` int(11) NOT NULL COMMENT 'Codigo de la operacion que se esta realizando',
  `cPerCodigo` varchar(20) NOT NULL COMMENT 'Codigo de la persona quien esta realizando una determinada transaccion.',
  `dTraFecha` datetime NOT NULL COMMENT 'Fecha en que se realiza una determinada transaccion.',
  `cComputer` varchar(250) NOT NULL COMMENT 'Descripcion del equipo que se esta utilizando',
  `cTraDescripcion` longtext NOT NULL COMMENT 'Descripcion de la transaccion que se esta realizando',
  PRIMARY KEY (`cTraCodigo`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 COMMENT='En esta tabla se registrara las transaciones que realiza un ';

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
