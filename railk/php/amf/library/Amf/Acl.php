<?php

class Amf_Acl extends Zend_Acl
{
    public function __construct()
    {
		//group
		$this->addRole(new Zend_Acl_Role('anonymous'));
		$this->addRole(new Zend_Acl_Role('admin'), 'anonymous');
		$this->addRole(new Zend_Acl_Role('superadmin'));
		$this->allow('superadmin');
    }
}