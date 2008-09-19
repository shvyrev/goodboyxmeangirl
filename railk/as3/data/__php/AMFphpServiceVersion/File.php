<?php
class File {

	function check( $filename ) 
	{
		if( file_exists( $filename ) ) return "true";
		else return "false";
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
		return ( $success = file_put_contents($filename, $bytearray) ) ? $filename : $success;
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
}
?>