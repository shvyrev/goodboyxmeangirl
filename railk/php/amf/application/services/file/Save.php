<?php
class File_Save {

	public function __construct() {
	}
	
	public function initAcl(Zend_Acl $acl) {
		$acl->allow('anonymous', 'File_Save', array('xml','bin') );
		return true;
	}

	public function xml($filename,$raw_xml) {
		$raw_xml = "<?xml version='1.0' encoding='utf-8' ?>\n".stripslashes( $raw_xml );
		if( file_exists( $filename ) ){ unlink($filename); touch($filename); $fp = fopen($filename, "w"); }
		else{ touch($filename); $fp = fopen($filename, "w"); }
		fwrite($fp, $raw_xml);
		fclose($fp);
		return $filename;
	}
	
	public function bin($filename,$bytearray) {
		$flux = $bytearray->data; 
		//$flux = gzuncompress($flux); 
		return ( $success = file_put_contents($filename, $flux) ) ? $filename : $success;
	}
}