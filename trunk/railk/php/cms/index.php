<?php

/////////////////////////////////////////////////////////////////
// ——————————————————————————————————————————————————————————————
// ERROR LEVEL SETTING (http://www.php.net/error_reporting)
// ——————————————————————————————————————————————————————————————

	error_reporting(E_ALL);

// ——————————————————————————————————————————————————————————————
// SYSTEM PATH
// ——————————————————————————————————————————————————————————————

	$system_folder = "system";
	
// ——————————————————————————————————————————————————————————————
// APPLICATION PATH
// ——————————————————————————————————————————————————————————————

	$application_folder = "site";
	
// ——————————————————————————————————————————————————————————————
// FRAMEWORK PATH
// ——————————————————————————————————————————————————————————————

	$framework_folder = "framework";

// ——————————————————————————————————————————————————————————————
// UTILS PATH
// ——————————————————————————————————————————————————————————————

	$utils_folder = "utils";		
	
/////////////////////////////////////////////////////////////////


/*
// ——————————————————————————————————————————————————————————————
// REAL PATH OF THE SYSTEM FOLDER
// ——————————————————————————————————————————————————————————————
|
| Let's attempt to determine the full-server path to the "system"
| folder in order to reduce the possibility of path problems.
| Note: We only attempt this if the user hasn't specified a 
| full server path.
|
*/
if (strpos($system_folder, '/') === FALSE)
{
	if (function_exists('realpath') AND @realpath(dirname(__FILE__)) !== FALSE)
	{
		$system_folder = realpath(dirname(__FILE__)).'/'.$system_folder;
	}
}
else
{
	// Swap directory separators to Unix style for consistency
	$system_folder = str_replace("\\", "/", $system_folder); 
}

/*
// ——————————————————————————————————————————————————————————————
// APPLICATION CONSTANT
// ——————————————————————————————————————————————————————————————
|
| EXT		- The file extension.  Typically ".php"
| FCPATH	- The full server path to THIS file
| SELF		- The name of THIS file (typically "index.php)
| BASEPATH	- The full server path to the "system" folder
| APPPATH	- The full server path to the "application" folder
|
*/
define('EXT', '.'.pathinfo(__FILE__, PATHINFO_EXTENSION));
define('FCPATH', __FILE__);
define('SELF', pathinfo(__FILE__, PATHINFO_BASENAME));
define('BASEPATH', $system_folder.'/');

//utils
define('JSPATH', $utils_folder.'/js');
define('CSSPATH', $utils_folder.'/css');
define('IMAGESPATH', $utils_folder.'/images');
define('FLASHPATH', $utils_folder.'/flash');


if (is_dir($application_folder))
{
	define('APPPATH', $application_folder.'/');
}
else
{
	if ($application_folder == '')
	{
		$application_folder = 'application';
	}

	define('APPPATH', BASEPATH.$application_folder.'/');
}

if (is_dir($framework_folder))
{
	define('FWPATH', $framework_folder.'/');
}
else
{
	if ($framework_folder == '')
	{
		$framework_folder = 'framework';
	}

	define('FWPATH', BASEPATH.$framework_folder.'/');
}


// ——————————————————————————————————————————————————————————————
// LOAD BASE CONTROLLER
// ——————————————————————————————————————————————————————————————
require_once FWPATH.'flow/Flow'.EXT;

