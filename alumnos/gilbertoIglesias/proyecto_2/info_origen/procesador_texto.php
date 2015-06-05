<?php
	function delete_accents($string){
		$patterns[0] = array("á","â","é","ê","í","ì","ó","ô","ú","û","ü","ñ");	
		$patterns[1] = array("Á","Â","É","Ê","Í","Î","Ó","Ô","Ú","Û","Ü","Ñ");	
		foreach($patterns as $pattern){
			foreach($pattern as $subp)
				$string = str_replace($subp, "", $string);
		}
		return $string;
	}
	
	function change_intermediate_accents($string){
		$string_final= "";
		$con = 0;
		$patterns[0] = array("á","â","é","ê","í","ì","ó","ô","ú","û","ü","ñ");	
		$patterns[1] = array("Á","Â","É","Ê","Í","Î","Ó","Ô","Ú","Û","Ü","Ñ");	
		foreach( str_split($string) as $char ){
			if ($con == 0)
				$string_final .= $char;
			else{
				$i=0;
				$char_final = $char;
				foreach($patterns[1] as $subp){
					$char_final = str_replace($subp, $patterns[0][$i], $char_final);
					$i++;
				}
				$string_final .= $char_final;
			}
			$con++;
		}
		return $string_final;
	}
	
	function change_accents($string){
		$string_final= "";
		$con = 0;
		$patterns[0] = array("a","a","e","e","i","i","o","o","u","u","u","ñ","A","A","E","E","I","I","O","O","U","U","U","Ñ");	
		$patterns[1] = array("á","â","é","ê","í","ì","ó","ô","ú","û","ü","ñ","Á","Â","É","Ê","Í","Î","Ó","Ô","Ú","Û","Ü","Ñ");	
		foreach( str_split($string) as $char ){
			if ($con == 0)
				$string_final .= $char;
			else{
				$i=0;
				$char_final = $char;
				foreach($patterns[1] as $subp){
					$char_final = str_replace($subp, $patterns[0][$i], $char_final);
					$i++;
				}
				$string_final .= $char_final;
			}
			$con++;
		}
		return $string_final;
	}
	
	function normaliza_nombre($nombre){
		$nombre = preg_replace("/^[\W]*/", "", $nombre);
		if ( count( explode(" ", $nombre) ) > 1 ){
			$nombre_final = "";
			$con = 1;
			foreach(explode(" ", $nombre) as $palabra){
				//echo $palabra . ": " . delete_accents($palabra) . "\n";
				if(ctype_upper($palabra) or ctype_upper(delete_accents($palabra)))
					$nombre_final .= " " . ucfirst(strtolower($palabra));
				else
					$nombre_final .= " " . $palabra;
			}
			$nombre_final = change_intermediate_accents($nombre_final);
		}
		else
			$nombre_final = $nombre;
		return preg_replace("/^[\W]*/", "", $nombre_final);
	}
	
	function get_profesion($cadena, $diccionario){
		$cadena_array = explode(" ", $cadena);
		$res = 0;
		$num_total = 0;
		$categorias = array();
		foreach($cadena_array as $cad){
			$palabra_final = preg_replace("/\W/", "",change_accents(strtolower($cad)));
			if(strlen($cad) >= 4)
				$num_total ++;
			foreach($diccionario as $dic => $id){
				if ( $palabra_final == $dic ){
					$res++;
					$categorias[$id] = $id;
				}
			}
		}
		//echo $res . ", " . count($cadena_array) . "\n";
		if($num_total > 0){
			if(  ( $res / $num_total) >= .2)
				return array("resultado" => True , "categorias" => $categorias);
			else
				return array("resultado" => False , "categorias" => $categorias);
		}
		else
			return array("resultado" => False , "categorias" => $categorias);
	}
	
	function reconoce_patrones_master($cadena, $id, $dic_profesion){
		//Extrae el nombre del renglon --------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------
		preg_match("/.*?[\s\S]?\/[\s\S]?/", $cadena, $nombre);
		//echo $nombre[0] . "\n";
		$cadena = str_replace($nombre[0], "", $cadena);
		$resultado = array();
		$resultado["id"] = $id;
		$resultado["nombre"] = "";
		$resultado["tipo_entidad"] = array();
		$resultado["dato_natalidad"] = "";
		$resultado["anio_nacimiento"] = -1;
		$resultado["anio_muerte"] = -1;
		$resultado["lugar_nacimiento"] = "";
		$resultado["lugar_muerte"] = "";
		$nombre_sp = explode(",", preg_replace("/[\s\S]?\/[\s\S]?$/", "", preg_replace("/^[\W]*/", "", $nombre[0] )) );
		if (! isset($nombre_sp[1]) ){
			$nombre_sp = $nombre_sp[0];
			$resultado["tipo_entidad"]["validacion_nombre_persona_inicial"] = false;
		}else{
			$nombre_sp = $nombre_sp[1] . " " . $nombre_sp[0];
			$resultado["tipo_entidad"]["validacion_nombre_persona_inicial"] = true;
		}
		$resultado["nombre"] = normaliza_nombre($nombre_sp);
		// Extrae los datos de nacimiento del renglon --------------------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------
		// El procedimiento es obtener una cadena de longitud 40 y buscar patrones en ese rango, que es donde se supone que deben estar los datos 
		// de natalidad y mortandad del individuo
		$cadena_temp = substr($cadena, 0, 40);
		preg_match("/(n\.)?.?(m\.)?\(([\d]{4}){1}-?([\d]{4})?\)./", $cadena_temp, $dato_natalidad);
		//var_dump($dato_natalidad);
		//Tiene año de nacimiento o muerte
		if( count($dato_natalidad) > 0){
			$resultado["dato_natalidad"] = substr($cadena_temp, 0, strpos($cadena_temp, $dato_natalidad[0])+ strlen($dato_natalidad[0]));
			$cadena = str_replace($resultado["dato_natalidad"], "", $cadena);
			$cadena = preg_replace("/^[\W]*/", "", $cadena);
			$resultado["tipo_entidad"]["validacion_dato_vida"] = "completo";
		}
		else{
			//Verifica si no tiene años pero tiene luegar de nacimientoo muerte
			preg_match("/(m\.)[\s\S](\w)+(\.)?/", $cadena_temp, $dato_natalidad);
			if( count($dato_natalidad) > 0){
				$resultado["dato_natalidad"] = substr($cadena_temp, 0, strpos($cadena_temp, $dato_natalidad[0])+ strlen($dato_natalidad[0]));
				$cadena = str_replace($resultado["dato_natalidad"], "", $cadena);
				$cadena = preg_replace("/^[\W]*/", "", $cadena);
				$resultado["tipo_entidad"]["validacion_dato_vida"] = "nacimiento_muerte";
			}
			else{
				preg_match("/^(n\.)[\s\S](\w)+(\.)?/", $cadena_temp, $dato_natalidad);
				if( count($dato_natalidad) > 0){
					$resultado["dato_natalidad"] = substr($cadena_temp, 0, strpos($cadena_temp, $dato_natalidad[0])+ strlen($dato_natalidad[0]));
					$cadena = str_replace($resultado["dato_natalidad"], "", $cadena);
					$cadena = preg_replace("/^[\W]*/", "", $cadena);
					$resultado["tipo_entidad"]["validacion_dato_vida"] = "nacimiento";				
				}
				else{
					$resultado["dato_natalidad"] = "";
					$resultado["tipo_entidad"]["validacion_dato_vida"] = "sin_dato";								
				}
			}
		}
		//Extrae los datos de lugar y año de nacimiento y muerte de la persona
		if($resultado["dato_natalidad"] != ""){
			//var_dump($resultado["dato_natalidad"]);
			preg_match("/([\d]{4}){1}-?([\d]{4})?/", $resultado["dato_natalidad"], $dato_natalidad);
			//var_dump($dato_natalidad);
			if( count ($dato_natalidad) > 0){
				if (strlen ($dato_natalidad[0]) > 4) {
					$dato_natalidad = explode ( "-", $dato_natalidad[0]); 
					$resultado["anio_nacimiento"] = $dato_natalidad[0];
					$resultado["anio_muerte"] = $dato_natalidad[1];
				}
				else{
					$resultado["anio_nacimiento"] = $dato_natalidad[0];
					$resultado["anio_muerte"] = -1;
				}
			}
			preg_match("/^(n\.\sy\sm\.){1}[\s\S](\w)+/", $resultado["dato_natalidad"], $dato_natalidad);
			if(count ($dato_natalidad) > 0){
				$dato_natalidad = preg_replace("/^(n\.\sy\sm\.){1}[\s\S]?/", "", $dato_natalidad[0]); 
				$dato_natalidad = preg_replace("/[\W]/", "", $dato_natalidad); 
				$resultado["lugar_nacimiento"] = $dato_natalidad;
				$resultado["lugar_muerte"] = $dato_natalidad;
			}
			else{
				//var_dump($resultado["dato_natalidad"]);
				preg_match("/^(n\.)[\s\S](\w)+/", $resultado["dato_natalidad"], $dato_natalidad);
				//var_dump($dato_natalidad);
				if( count ($dato_natalidad) > 0){
					$dato_natalidad = preg_replace("/^(n\.)[\s\S\W]?/", "", $dato_natalidad[0]); 
					$dato_natalidad = preg_replace("/[\W]/", "", $dato_natalidad); 
					$resultado["lugar_nacimiento"] = $dato_natalidad;
				}
				//var_dump($resultado["dato_natalidad"]);
				preg_match("/(m\.)[\s\S](\w)+/", $resultado["dato_natalidad"], $dato_natalidad);
				//var_dump($dato_natalidad);
				if( count ($dato_natalidad) > 0){
					$dato_natalidad = preg_replace("/^(m\.)[\s\S\W]?/", "", $dato_natalidad[0]); 
					$dato_natalidad = preg_replace("/[\W]/", "", $dato_natalidad);
					$resultado["lugar_muerte"] = $dato_natalidad;
				}
			}
		}
		//Extrae los datos de profesion del renglon ------------------------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------
		//El procedimiento es obtener la cadena hasta el primer renglon, normalizarla y revisarlacontra una lista de terminos de profesiones
		preg_match("/^(.*?)\./", $cadena, $dato_profesion);
		if(count($dato_profesion) > 0) {
			$res_profesion_persona = get_profesion($dato_profesion[0], $dic_profesion);
			$resultado["tipo_entidad"]["validacion_dato_profesion"] = $res_profesion_persona["resultado"];
			$resultado["categorias"] = $res_profesion_persona["categorias"];
			if($resultado["tipo_entidad"]["validacion_dato_profesion"] == True){
				$resultado["dato_profesion"] = preg_replace("/\­/", "", $dato_profesion[0]);
				$cadena = str_replace($dato_profesion[0], "", $cadena);
				$cadena = preg_replace("/^[\W]*/", "", $cadena);
			}
			else{
				$resultado["dato_profesion"] = "";
			}
		}
		else{
			$resultado["dato_profesion"] = "";
			$resultado["tipo_entidad"]["validacion_dato_profesion"] = "sin_dato";				
		}
		$resultado["cadena"] = $cadena;
		//Verificacion final del tipo de persona -----------------------------------------------------------------------
		// ------------------------------------------------------------------------------------------------------------------------------
		if( $resultado["tipo_entidad"]["validacion_nombre_persona_inicial"] == true ){
			if($resultado["tipo_entidad"]["validacion_dato_vida"] != "sin_dato" or $resultado["tipo_entidad"]["validacion_dato_profesion"] == True){
				$resultado["tipo_entidad"] = "persona";
			}
			else
				$resultado["tipo_entidad"] = "sin_clasificar";
		}
		else{
			$resultado["tipo_entidad"] = "sin_clasificar";
		}
		return $resultado;
	}
	
	function inserta_odoo($conexion, $res){
		$query = "INSERT INTO escenologia_entidades (id, name, dato_natalidad_mortandad, dato_profesion, dato_exp, tipo_entidad, ";
		$query .= "validado, anio_nacimiento, anio_muerte, lugar_nacimiento, lugar_muerte) ";
		$query .= " VALUES (" . $res["id"] . ", '" . utf8_encode($res["nombre"]) . "', '" . utf8_encode($res["dato_natalidad"]) . "', ";
		$query .= "'" . utf8_encode($res["dato_profesion"]) . "', ";
		$query .= "'" . htmlentities(utf8_encode($res["cadena"]), 0, 'UTF-8') . "', '" . utf8_encode($res["tipo_entidad"]) . "', False, ";
		$query .= " " . $res["anio_nacimiento"] . ", " . $res["anio_muerte"] . ", '" . $res["lugar_nacimiento"] . "', '" . $res["lugar_muerte"] . "' )";
		//echo $query . "\n";
		$res_q = pg_query($conexion, $query);
		if($res_q == False){
			echo $query . "\n";
			echo  pg_last_error() . "\n";
		}
		else{
			//var_dump(count($res["categorias"]), $res["categorias"]);
			if ( count($res["categorias"]) > 0 ){
				foreach($res["categorias"] as $cat){
					$query = "INSERT INTO escenologia_entidades_categorias_rel (partner_id, category_id) VALUES (" . $res["id"] . "," . $cat . ");";
					//echo $query . "\n";
					$res_q = pg_query($conexion, $query);
					if($res_q == False){
						echo $query . "\n";
						echo  pg_last_error() . "\n";
					}
				}
			}
		}
	}
	
	function inserta_odoo_cat($conexion, $categorias){
		$id_viejo = -1;
		foreach($categorias as $cat => $id){
			if($id != $id_viejo){
				$id_viejo = $id;
				$query = "INSERT INTO escenologia_entidades_categorias (id, name, descripcion, create_uid, create_date) ";
				$query .= " VALUES (" . $id . ", '" . utf8_encode(ucfirst($cat)) . "', '" . utf8_encode(ucfirst($cat)) . "', 1, now() );";
				echo $query . "\n";
				$res_q = pg_query($conexion, $query);
				if($res_q == False){
					echo $query . "\n";
					echo  pg_last_error() . "\n";
				}
			}
		}
	}
	
	$usuario = "odoo_optimit";
	$contrasena = "odoo_optimit_123$%67()";
	$servidor = "localhost";
	$puerto = "5432";
	$bd = "escenologia";
	$conexion = pg_connect("host=" .$servidor ." dbname=" .$bd ." port=" .$puerto ." user=" .$usuario ." password=" .$contrasena ."")or die ("error de conexión");
	
	$dic_profesion = array("actor" => 1, "actriz"  => 1, "director"  => 2, "directora" => 2, "cantante" => 3, "dramaturgo" => 4, "dramaturga" => 4, "periodista" => 5,
			"escritor" => 6, "escritora" => 6, "bailarin" => 7, "escenografo" => 8, "escenografa" => 8, "iluminador" => 9, "iluminadora" => 9, 
			"coreografo" => 10, "coreografa" => 10, "musico" => 11, "vestuarista" => 12, "docente" => 13, "musicologo" => 14, "musicologa" => 14, "critico" => 15, "critica" => 15, 
			"cronista" => 16, "guionista" => 17, "argumentista" => 18, "titiritero" => 19, "titiritera" => 19, "autor" => 20, "autora" => 20, 
			"comediografo" => 21, "comediante" => 22, "egresado" => 23, "egresada" => 23, "caricaturista" => 24, "folclorista" => 25, "letrista" => 26, 
			"productor" => 27, "productora" => 27, "compositor" => 28, "compositora" => 28, "investigador" => 29, "investigadora" => 29, "poeta" => 30,
			"baritono" => 31, "soprano" => 32, "libretista" => 33, "medico" => 34, "novelista" => 35, "mascarero" => 36, "fundador" => 37, "fundadora" => 37,
			"propietario" => 38, "propietaria" => 38, "empresario" => 39, "empresaria" => 39
			);
			
	if($argv[1] == "1")
		inserta_odoo_cat($conexion, $dic_profesion);
	$con = $argv[2];
	while($f = fgets(STDIN)){
		$res = reconoce_patrones_master(utf8_decode($f), $con, $dic_profesion);
		//echo $con . ":". utf8_decode($f);
		echo $res["nombre"] . "\n";
		//echo $res["tipo_entidad"] . "\n";
		//echo $res["dato_natalidad"] . "\n";
		//echo $res["dato_profesion"] . "\n";
		//echo $res["cadena"] . "\n";
		inserta_odoo($conexion, $res);
		$con++;
	}
	pg_close($conexion); 
?>