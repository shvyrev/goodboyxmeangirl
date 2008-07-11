<?php
	/////////////////////////////////////////////////////////////////
	//                   sauvegarde et création de fichier xml     //
	/////////////////////////////////////////////////////////////////
	
	//on recupere les données en POST
	$raw_xml = $_POST['xml'];
	$filename = $_POST['nom'];

	//on cerche dans les données xml ou doit etre créer/sauvegarder le fichier
	$filename = "../".$filename;
	$raw_xml = "<?xml version='1.0' encoding='utf-8' ?>\n".stripslashes( $raw_xml );
	
	//on vérifie si le fichier existe ou non pour le créer si besoin est
	if( file_exists( $filename ) ){ unlink($filename); touch($filename); $fp = fopen($filename, "w"); }
	else{ touch($filename); $fp = fopen($filename, "w"); }
	//ecriture du fichier et fermeture
	fwrite($fp, $raw_xml);
	fclose($fp);
	//retour du fichier
	echo $filename;
?>