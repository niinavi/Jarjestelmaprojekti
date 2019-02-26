<?php
$nimi = $_POST["nimi"];
$pituus = strlen($nimi);
$nimi = htmlspecialchars($nimi);
echo "Nimesi on {$nimi} ja siinä on {$pituus} kirjainta.";
?>
