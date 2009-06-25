<?php

require_once 'Amf/Auth.php';
require_once 'Amf/Acl.php';

class IndexController extends Zend_Controller_Action
{
    public function init()
    {
		$this->_helper->viewRenderer->setNoRender();
    }

    public function indexAction()
    {
		$this->server = new Zend_Amf_Server();
		Zend_Session::start();
		
		$this->server->setSession(Amf_Auth::AUTH_NAMESPACE);
		$this->server->setProduction(false);
		$this->server->addDirectory('application/services');
		$this->server->setAuth( new Amf_Auth() );
		$this->server->setAcl( new Amf_Acl() );
		Zend_Session::regenerateId();
		
		$response = $this->server->handle();
		Zend_Session::destroy();
		if (count($response-> getAmfBodies()) > 0) echo $response;
    }
}