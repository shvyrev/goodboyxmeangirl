<?php
	/////////////////////////////////////////////////////////////////
	//                   sauvegarde et création de fichier         //
	/////////////////////////////////////////////////////////////////
	
	if ( isset ( $GLOBALS["HTTP_RAW_POST_DATA"] )) {
	
		// get bytearray
		$data = $GLOBALS["HTTP_RAW_POST_DATA"];
		$filename = $_GET['nom'];
		$filetype = $_GET['filetype'];
		
		// add headers for download dialog-box
		header("Content-Type:".$filetype);
		header("Content-Disposition: attachment; filename=".$filename);
		echo $data;
		
	}  else echo 'An error occured.';
?>