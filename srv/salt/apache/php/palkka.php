<!DOCTYPE html>
<html>
  <head>
    <title>Ensimmäinen PHP-sivu</title>
  </head>
  <body>
    <?php
	$tuntipalkka = $_POST["tuntipalkka"];
	$tuntimaara = $_POST["tuntimaara"];
	$yhteispalkka = $tuntipalkka * $tuntimaara;
	echo "Yhteispalkka: " . $yhteispalkka;
	?>
  </body>
</html>
