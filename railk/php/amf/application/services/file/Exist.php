<?php
class File_Exist {

	public function __construct() {
	}
	
	public function initAcl(Zend_Acl $acl) {
		$acl->allow('anonymous', 'File_Exist', array('url','dir'));
		return true;
	}

	public function url( $filename,$url ) {
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
	
	public function dir($path) {
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