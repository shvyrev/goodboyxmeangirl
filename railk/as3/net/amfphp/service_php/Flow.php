<?php
class Flow
{
	/*var $executeRoles = "admin";

	function beforeFilter($function_called)
	{
		$memberName = $function_called."Roles";
		return (@$this->$memberName) ? Authenticate::isUserInRole($this->$memberName) : true;
	}*/

	/**
	 * this service execute a function in the amf controller
	 * $return Object
	 */ 
	function execute($method, $args=false)
    {
        define('AMFPHP', 1);

        global $value;
		global $CI;
		
		$root = $_SERVER['DOCUMENT_ROOT']; 
		require_once($root.'cms/amfphp.php');
		
		
		if ( $args == false ) $args = array();
		
		//validate vars
		if ( ! is_array( $args ) )
		{
			return "error arguments must be an array";
		}
		else
		{
			if (method_exists($CI, $method))
			{
				call_user_func_array(array(&$CI, $method), $args );
				return $value;
			}	
			else
			{
				return "error method doesn't exist";
			}
		}
    }
}
?>