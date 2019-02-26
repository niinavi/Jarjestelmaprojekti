<?php
	include("connection.php");

	$id = htmlspecialchars($_GET["id"]);

	$sql = "DELETE FROM books WHERE id = (:id)";

	$query = $con->prepare($sql);
	$query->bindParam(':id', $id);
	$query->execute();

	echo "<h2>Book deleted </h2>";
	
	echo "<p><a href='list.php'>Back to Booklist</a>";
?>
