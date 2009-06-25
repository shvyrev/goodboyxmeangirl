<?php

class Bootstrap extends Zend_Application_Bootstrap_Bootstrap
{
	protected function _initAutoload()
    {
		$autoLoader =  new Zend_Loader_Autoloader_Resource(array(
            'basePath'      => APPLICATION_PATH,
            'namespace'     => '',
        ));
        return $autoLoader;
    }
	
	/**
     * Initialize data base
     *
     */
    protected function _initConfig()
    {
		$config = new Zend_Config_Xml(APPLICATION_PATH .  '/configs/config.xml', APPLICATION_ENV);
        $registry = Zend_Registry::getInstance();
        $registry->set('config', $config);
		return $config;
	}
	
    /**
     * Initialize data base
     */
    protected function _initDb()
    {
		$this->bootstrap('config');
        $config = $this->getResource('config');
        // Setup database
        $db = Zend_Db::factory($config->database->adapter, $config->database->toArray());
        $db->setFetchMode(Zend_Db::FETCH_OBJ);
        $db->query("SET NAMES 'utf8'");
        $db->query("SET CHARACTER SET 'utf8'");
        Zend_Db_Table::setDefaultAdapter($db);
        return $db;
    }
}