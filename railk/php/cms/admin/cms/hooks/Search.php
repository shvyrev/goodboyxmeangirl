<?php

if (!defined('BASEPATH')) exit('No direct script access allowed');

class Search
{    
    /**
     * includes the directory application\mailer\ in your includes directory
     *
     */
    function index()
    {
        //includes the directory application\mailer\
       //for PHP/APACHE on windows platforms change the ':' before BASEPATH to ';'
        ini_set('include_path', ini_get('include_path').';'.BASEPATH.'application/search/');
    }
}

?> 