<?php

class Amf_Auth extends Zend_Amf_Auth_Abstract
{
    private $_authAdapter;
    private $_dbAdapter;
    private $_storage;
    private $_isValid=false;

    protected  $_userTable = "users";
    protected  $_identityColumn = "email";
    protected  $_credentialColumn = "password";
    
    const AUTH_NAMESPACE = 'kkyeosseyo';
    
    protected $_resultRowColumns = array('id', 'user_group_id', 'first_name', 'last_name', 'email', 'role', 'acl_resources');
    
    /**
     * build the login request
     *
     * @param string $username
     * @param string $password
     */
    public function __construct()
    {
        $this->_dbAdapter = clone (Zend_Db_Table::getDefaultAdapter());
        $this->_dbAdapter->setFetchMode(zend_db::FETCH_ASSOC );
        $this->_authAdapter = new Zend_Auth_Adapter_DbTable($this->_dbAdapter, $this->_userTable, $this->_identityColumn, $this->_credentialColumn);
    }
	
	/**
     * Returns the persistent storage handler
     *
     * Session storage is used by default unless a different storage adapter has been set.
     *
     * @return Zend_Auth_Storage_Interface
     */
    public function getStorage()
    {
        if (null === $this->_storage) {
            /**
             * @see Zend_Auth_Storage_Session
             */
            require_once 'Zend/Auth/Storage/Session.php';
            $this->setStorage(new Zend_Auth_Storage_Session(self::AUTH_NAMESPACE));
        }

        return $this->_storage;
    }

    /**
     * Sets the persistent storage handler
     *
     * @param  Zend_Auth_Storage_Interface $storage
     * @return Zend_Auth Provides a fluent interface
     */
    public function setStorage(Zend_Auth_Storage_Interface $storage)
    {
        $this->_storage = $storage;
        return $this;
    }

    /**
     * authenticate the request
     *
     * @return zend_auth_response
     */
    public function authenticate()
    {
        //authenticate the user
        $this->_authAdapter->setIdentity(htmlspecialchars(base64_decode($this->_username)));
        $this->_authAdapter->setCredential(md5(htmlspecialchars(base64_decode($this->_password))));

        $result = $this->_authAdapter->authenticate();

        if ($result->isValid()) {
            $this->_isValid = true;
			Zend_Session::regenerateId();
			$this->getStorage()->write($this->_authAdapter->getResultRowObject($this->_resultRowColumns));
            return $this;
        }
    }
	
	/**
     * Returns true if isValid
     *
     * @return boolean
     */
    public function isValid()
    {
        return $this->_isValid;
    }
	
	/**
     * Returns true if and only if an identity is available from storage
     *
     * @return boolean
     */
    public function hasIdentity()
    {
        return !$this->getStorage()->isEmpty();
    }

    /**
     * Returns the identity from storage or null if no identity is available
     *
     * @return mixed|null
     */
    public function getIdentity()
    {
        $storage = $this->getStorage();

        if ($storage->isEmpty()) {
            return null;
        }

        return $storage->read();
    }

    /**
     * Clears the identity from persistent storage
     *
     * @return void
     */
    public function clearIdentity()
    {
        $this->getStorage()->clear();
    }
}