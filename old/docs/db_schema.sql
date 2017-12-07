CREATE TABLE `accounts` (
  `account_id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(145) DEFAULT NULL,
  `email` varchar(145) DEFAULT NULL,
  `language` varchar(4) DEFAULT NULL,
  `time_zone` varchar(5) DEFAULT NULL,
  `password` varchar(155) DEFAULT NULL,
  `last_login_on` date DEFAULT NULL,
  `password_reset_expires` datetime DEFAULT NULL,
  `password_reset_key` varchar(45) DEFAULT NULL,
  `is_admin` int(1) NOT NULL DEFAULT '0',
  `active` int(1) NOT NULL DEFAULT '1',
  `step` int(11) DEFAULT NULL,
  PRIMARY KEY (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `project_registry` (
  `project_id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL DEFAULT '0',
  `categoria` varchar(50) DEFAULT NULL,
  `disciplina` varchar(50) DEFAULT NULL,
  `tipo_proyecto` varchar(50) DEFAULT NULL,
  `folio` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`project_id`),
  KEY `project_registry_ibfk_1` (`account_id`),
  CONSTRAINT `project_registry_ibfk_1` FOREIGN KEY (`account_id`) REFERENCES `accounts` (`account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `project_participants_documents` (
  `documents_id` int(11) NOT NULL AUTO_INCREMENT,
  `participant_id` int(11) NOT NULL,
  `project_id` int(11) NOT NULL,
  `carta_solicitud` varchar(70) DEFAULT NULL,
  `acta_de_nacimiento` varchar(70) DEFAULT NULL,
  `comprobante_de_domicilio` varchar(70) DEFAULT NULL,
  `identificacion_oficial` varchar(70) DEFAULT NULL,
  `CURP` varchar(70) DEFAULT NULL,
  `curriculum` varchar(70) DEFAULT NULL,
  `carta_compromiso` varchar(70) DEFAULT NULL,
  `uploaded` int(1) DEFAULT '0',
  PRIMARY KEY (`documents_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_participants` (
  `participant_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `nombres` varchar(100) DEFAULT NULL,
  `apellido_paterno` varchar(70) DEFAULT NULL,
  `apellido_materno` varchar(70) DEFAULT NULL,
  `email` varchar(80) DEFAULT NULL,
  `telefono` varchar(15) DEFAULT NULL,
  `celular` varchar(15) DEFAULT NULL,
  `direccion_actual` varchar(255) DEFAULT NULL,
  `CURP` varchar(20) DEFAULT NULL,
  `fecha_de_nacimiento` varchar(100) DEFAULT NULL,
  `lugar_de_nacimiento` varchar(70) DEFAULT NULL,
  `nacionalidad` varchar(45) DEFAULT NULL,
  `grado_de_estudios` varchar(20) DEFAULT NULL,
  `representante_de_equipo` int(1) DEFAULT '0',
  PRIMARY KEY (`participant_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_information` (
  `project_info_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `nombre` varchar(200) DEFAULT NULL,
  `antecedentes` text,
  `justificacion` text,
  `objetivo_general` text,
  `objetivos_especificos` text,
  `metas` text,
  `beneficiarios` text,
  `contexto` text,
  PRIMARY KEY (`project_info_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

CREATE TABLE `project_documents` (
  `project_documents_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `cronograma_actividades` varchar(70) DEFAULT NULL,
  `fuentes_financiamiento` varchar(70) DEFAULT NULL,
  `desglose_de_gastos` varchar(70) DEFAULT NULL,
  PRIMARY KEY (`project_documents_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `project_retribution` (
  `retribution_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `modalidad` text,
  `actividad_a_realizar` varchar(70) DEFAULT NULL,
  `descripcion_actividad` text,
  `numero_contribuciones` varchar(70) DEFAULT NULL,
  `carta_compromiso_retribucion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`retribution_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `evidencia_teatro` (
  `evidencia_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `documentos` int(11) NOT NULL DEFAULT '0',
  `imagenes` int(11) NOT NULL DEFAULT '0',
  `videomuestra` text,
  `sitioweb` text,
  `guion` varchar(150) DEFAULT NULL,
  `carta_de_autorizacion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`evidencia_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `evidencia_musica` (
  `evidencia_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `videomuestra` text,
  `sitioweb` text,
  `documentos` int(11) NOT NULL DEFAULT '0',
  `imagenes` int(11) NOT NULL DEFAULT '0',
  `partituras` int(11) NOT NULL DEFAULT '0',
  `grabacion` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`evidencia_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `evidencia_letras` (
  `evidencia_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `texto_inedito` text,
  `portadas` int(11) NOT NULL DEFAULT '0',
  `sitioweb` text,
  PRIMARY KEY (`evidencia_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `evidencia_danza` (
  `evidencia_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `sitioweb` text,
  `videomuestra` text,
  `imagenes` int(11) NOT NULL DEFAULT '0',
  `documentos` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`evidencia_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `evidencia_cine_video` (
  `evidencia_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) DEFAULT NULL,
  `videomuestra` text,
  `cortometraje` varchar(100) DEFAULT NULL,
  `guion` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`evidencia_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

CREATE TABLE `evidencia_artes_visuales` (
  `evidencia_id` int(11) NOT NULL AUTO_INCREMENT,
  `project_id` int(11) NOT NULL,
  `catalogo` int(11) NOT NULL DEFAULT '0',
  `imagenes` int(11) NOT NULL DEFAULT '0',
  `notas` int(11) NOT NULL DEFAULT '0',
  `documentos` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`evidencia_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
