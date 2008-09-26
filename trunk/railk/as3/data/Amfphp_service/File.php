<?php
class File {

	function check( $filename ) 
	{
		if( file_exists( $filename ) ) return true;
		else return false;
	}
	
	function upload( $filename, $path) 
	{
		move_uploaded_file($filename,$path);
	}
	
	function saveXml($filename,$raw_xml)
	{
		$raw_xml = "<?xml version='1.0' encoding='utf-8' ?>\n".stripslashes( $raw_xml );
		if( file_exists( $filename ) ){ unlink($filename); touch($filename); $fp = fopen($filename, "w"); }
		else{ touch($filename); $fp = fopen($filename, "w"); }
		fwrite($fp, $raw_xml);
		fclose($fp);
		return $filename;
	}
	
	function saveLocal($filename,$filetype,$data)
	{
		header("Content-Type:".$filetype);
		header("Content-Disposition: attachment; filename=".$filename);
		echo $data;
	}
	
	function saveServer($filename,$bytearray)
	{
		$flux = $bytearray->data; 
		$flux = gzuncompress($flux); 
		$ecriture = file_put_contents($filename, $flux);
		return $ecriture !== FALSE;
	}
	
	function dir($path)
	{
		$files = array();
		$dossier = opendir($path);
		while ($fichier = readdir($dossier)) {
		   if ($fichier != "."&&$fichier != "..") {
			  array_push($files,$fichier);
		   }
		}
		 
		$returnFiles = implode(",",$files);
		return $returnFiles;
	}
	
	function load($filename,$type)
	{
		switch($type)
		{
			case "xml" :
				$a = array( content=>file_get_contents($filename), type=>'txt' );
				return $a;
				break;
			case "binary" :
				$a = array( content=>new Bytearray( file_get_contents($filename) ), type=>'binary' ); 
				return $a;
				break;
		}
		
	}
}
?>