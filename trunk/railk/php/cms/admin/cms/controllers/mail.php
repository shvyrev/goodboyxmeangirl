<?php
class Mail extends Controller
{
    function Mail()
    {
        parent::Controller();
        
    }
    
    function index()
    {
        //Load in the files we'll need
        require_once "Swift.php";
        require_once "Swift/Connection/SMTP.php";
         
        //Start Swift
        $swift =& new Swift(new Swift_Connection_SMTP("your.smtp.com"));
         
        //Create the message
        $message =& new Swift_Message("My subject", "My body");
         
        //Now check if Swift actually sends it
        if ($swift->send($message, "recipient@email.com", "sender@email.com")) echo "Sent";
        else echo "Failed";
    }
}

?> 