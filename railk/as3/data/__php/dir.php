<?php
$nomRepertoire = "../images";
$myFiles = array(); //on se cree un tableau de fichiers
$dossier = opendir ($nomRepertoire);
while ($fichier = readdir ($dossier)) {
   if ($fichier != "."&&$fichier != "..") {
      array_push($myFiles,$fichier); //on ajoute le fichier au tableau
   }
}
 
$returnFiles = implode(":",$myFiles); //ici on obtient  fichier1:fichier2:fichier3
$returnFiles = urlencode($returnFiles); //on le decrit en URL pour un LoadVars
echo "&fichiers=$returnFiles";
 
closedir ($dossier);
?>