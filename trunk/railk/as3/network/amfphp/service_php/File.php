<?php
class File {

	function check( $filename,$url ) 
	{
		if ($url)
		{
			$hdrs = @get_headers($filename);
			return is_array($hdrs) ? (boolean)preg_match('/^HTTP\\/\\d+\\.\\d+\\s+2\\d\\d\\s+.*$/',$hdrs[0]) : false; 
		}
		else
		{
			if( file_exists($filename) ) return true;
			else return false;
		}
		
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
	
	function saveFile($filename,$bytearray)
	{
		$flux = $bytearray->data; 
		//$flux = gzuncompress($flux); 
		return ( $success = file_put_contents($filename, $flux) ) ? $filename : $success;
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
				$a = file_get_contents($filename);
				break;
			case "binary" :
				$a = new Bytearray( file_get_contents($filename) ); 
				break;
		}
		return $a;
	}
}
?>