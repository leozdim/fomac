CREATE TABLE `steps_account` (
  `step_id` int(11) NOT NULL,
  `account_id` int(10) NOT NULL,
  `is_completed` int(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `steps_account` VALUES (1,20,1),(2,20,1),(3,20,1),(4,20,0),(5,20,0),(6,20,0);

CREATE TABLE `steps` (
  `step_id` int(11) NOT NULL AUTO_INCREMENT,
  `step_title` varchar(70) NOT NULL,
  `tooltip_step` varchar(70) DEFAULT NULL,
  `tooltip_title` varchar(70) DEFAULT NULL,
  `tooltip_description` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`step_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

INSERT INTO `steps` VALUES 
(1,'Registro','Primer Paso','Registro del proyecto','En esta paso registaras la categoria y disciplina en la que deseas participar'),
(2,'Participantes','Segundo Paso','Registra a los participante(s)','Aqui registra a el/los participante(s)'),
(3,'Anexos','Tercer Paso','Descarga de anexos','Descarga la documentación necesaria para pasos futuros'),
(4,'Documentos','Cuarto Paso','Documentación de los participante(s)','Sube la documentacion solicitada'),
(5,'Proyecto','Quinto Paso','Descripción del proyecto','Describir los datos generales del proyecto'),
(6,'Retribución','Sexto Paso','Retribución social','Describir como van a retribuir a la sociedad la ayuda otorgada'),
(7,'Evidencias','Septimo Paso','Evidencias y documentación del proyecto','Sube tu cronograma de actividades, desglose de gastos y evidencias del proyecto');
