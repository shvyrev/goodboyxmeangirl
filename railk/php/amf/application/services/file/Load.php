<?php
class File_Load {

	public function __construct() {
	}
	
	public function initAcl(Zend_Acl $acl) {
		$acl->allow('anonymous', 'File_Load', array('bin','xml'));
		return true;
	}
	
	public function bin($filename) {
		return new ByteArray(file_get_contents($filename));
	}
	
	public function xml($filename) {
		return = file_get_contents($filename);
	}
}