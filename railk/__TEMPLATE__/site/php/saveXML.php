<?php
	/////////////////////////////////////////////////////////////////
	//                   sauvegarde et cr�ation de fichier xml     //
	/////////////////////////////////////////////////////////////////
	
	//on recupere les donn�es en POST
	$raw_xml = $_POST['xml'];
	$filename = $_POST['nom'];

	//on cerche dans les donn�es xml ou doit etre cr�er/sauvegarder le fichier
	$filename = "../".$filename;
	$raw_xml = "<?xml version='1.0' encoding='utf-8' ?>\n".stripslashes( $raw_xml );
	
	//on v�rifie si le fichier existe ou non pour le cr�er si besoin est
	if( file_exists( $filename ) ){ unlink($filename); touch($filename); $fp = fopen($filename, "w"); }
	else{ touch($filename); $fp = fopen($filename, "w"); }
	//ecriture du fichier et fermeture
	fwrite($fp, $raw_xml);
	fclose($fp);
	//retour du fichier
	echo $filename;
?>