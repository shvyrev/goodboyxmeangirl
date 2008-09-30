<?php
class Database {

	var $connect;
	var $result;

	function execute($method,$connexion,$args)
    {
		if ( ! is_array( $args ) )
		{
			return "error arguments must be an array";
		}
		else
		{
			if (method_exists($this, $method))
			{
				$this->_connect($connexion);
				call_user_func_array(array($this, $method), $args );
				mysql_close();
				return $result;
			}	
			else
			{
				return "error method doesn't exist";
			}
		}
	}
	
	function _connect($args)
	{
		$this->connect = mysql_connect($args[0], $args[1], $args[2]);
		if ( !$this->connect ) $this->result = "connection error";
		$db_selected = mysql_select_db('nombase', $this->connect);
		if (!$db_selected) $this->result = "database doesn't exist";
	}
	
	function _initSession()
	{
		session_start();
		if (!isset($_SESSION['initiated']))
		{
			session_regenerate_id();
			$_SESSION['initiated'] = true;
		}
		if (isset($_SESSION['HTTP_USER_AGENT']))
		{
			if ($_SESSION['HTTP_USER_AGENT'] != md5($_SERVER['HTTP_USER_AGENT']))
			{
				$this->result = false;
				exit;
			}
		}
		else $_SESSION['HTTP_USER_AGENT'] = md5($_SERVER['HTTP_USER_AGENT']);
	}
	
	function _createDB_table($args)
	{	
		mysql_query($args[0],$this->connect);
		$this->result = "tables crייes";
	}
	
	function _insertUser($args)
	{
		$result = mysql_query("INSERT INTO USERS Values(Null,".$args[0].",".$args[1].",".$args[2].")", $this->connect );
		$this->result = true;
	}
	
	function _autoLogin()
	{
		$this->_initSession();
		if ( isset($_SESSION['name']) && isset($_SESSION['pass']) )
		{
			$name = mysql_real_escape_string($_SESSION['name']);
			$pass = mysql_real_escape_string($_SESSION['pass']);
			$result = mysql_query("SELECT COUNT(*) AS NUMBER FROM USERS WHERE name='{$name}' AND pass='{$pass}'");
			$num = mysql_result($result,0,"NUMBER");
			if ($num > 0) $this->result = true;
			else $this->result = false;
		}
		else $this->result = false;
	}
	
	function _login($args)
	{
		$this->_initSession();
		$name = mysql_real_escape_string($args[0]);
		$pass = mysql_real_escape_string($args[1]);
		
		$result = mysql_query("SELECT COUNT(*) AS NUMBER FROM USERS WHERE name='{$name}' AND pass='{$pass}'");
		$num = mysql_result($result,0,"NUMBER");
		if ($num > 0)
		{	
			$_SESSION['name'] = $name;
			$_SESSION['pass'] = $pass;
			$this->result = true;
		}
		else $this->result = false;
	}
	
	function _logout()
	{	
		session_destroy();
		$this->result = true;
	}
}
?>