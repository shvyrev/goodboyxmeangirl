<?php
//on recupere les donn�es en POST
$filename = file_get_contents("php://input");
//on verifie si le fihier exite ou non
if( file_exists( "../".$filename ) ){ echo "true"; }
else{ echo "false"; }
?>