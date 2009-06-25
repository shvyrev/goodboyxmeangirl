<?php
require_once "mailer/Swift.php";
require_once "mailer/Swift/Connection/SMTP.php";

class Mail {	
	
	public function __construct() {
	}
	
	public function initAcl(Zend_Acl $acl) {
		$acl->allow('admin', 'Hello_World', 'say');
		return true;
	}
	
	public function checkMail( $mail ) 
	{
		$result = false;
		list($prefix, $domain) = split("@",$mail);	
		if(function_exists("getmxrr") && getmxrr($domain, $mxhosts)) $result=  true;
        elseif (@fsockopen($domain, 25, $errno, $errstr, 5)) $result=  true;
        else $result=  false;		
		return $result;
	} 
	
	public function sendMail($from,$to,$titre,$text)
	{
		//$swift =& new Swift(new Swift_Connection_SMTP("smtp.wanadoo.fr", 25));
		$swift =& new Swift(new Swift_Connection_SMTP("localhost", 25));
		
		$message = & new Swift_Message($titre,$text,"text/html");
		if ($swift->send($message, $to, $from)) return  "Message envoyé";
		else return "Message non envoyé";
		$swift->disconnect();
	}
}
?>