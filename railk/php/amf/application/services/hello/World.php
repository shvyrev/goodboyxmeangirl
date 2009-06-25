<?php

Class Hello_World
{
	public function __construct() {
	}
	
	public function initAcl(Zend_Acl $acl) {
		$acl->allow('anonymous', 'Hello_World', 'say');
		return true;
	}
	
	public function say($name, $greeting = 'Hello') {
		return $greeting . ', ' . $name[0];
	}
}