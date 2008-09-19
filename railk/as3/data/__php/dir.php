<?php
$nomRepertoire = "../images";
$myFiles = array();
$dossier = opendir ($nomRepertoire);
while ($fichier = readdir ($dossier)) {
   if ($fichier != "."&&$fichier != "..") {
      array_push($myFiles,$fichier);
   }
}
 
$returnFiles = implode(":",$myFiles);
echo "&fichiers=$returnFiles";
 
closedir ($dossier);
?>