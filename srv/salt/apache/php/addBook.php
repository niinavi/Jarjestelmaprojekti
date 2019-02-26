<?php
	include("connection.php");

	$name = htmlspecialchars($_POST["name"]);

	$sql = "INSERT INTO books (name)
        	VALUES (:name)";

	$query = $con->prepare($sql);
	$query->bindParam(':name', $name);
	$query->execute();

	print ("<h2>Added book: {$name}</h2>"); 
	print ("<p><a href='list.php'>Back to booklist</a></p>");

?>

