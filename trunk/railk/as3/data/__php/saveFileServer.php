<?php
	/////////////////////////////////////////////////////////////////
	//                   sauvegarde et cr�ation de fichier         //
	/////////////////////////////////////////////////////////////////
	
	$path = $_GET['path'];
	
	if ( isset ( $GLOBALS["HTTP_RAW_POST_DATA"] )) {
	
		// get bytearray
		$data = $GLOBALS["HTTP_RAW_POST_DATA"];
		
		//on v�rifie si le fichier existe ou non pour le cr�er si besoin est
		if( file_exists( $path ) ){ unlink($path); touch($path); $fp = fopen($path, "wb"); }
		else{ touch($path); $fp = fopen($path, "wb"); }
		//ecriture du fichier et fermeture
		fwrite($fp, $data);
		fclose($fp);
		
	}  else echo 'An error occured.';
?>