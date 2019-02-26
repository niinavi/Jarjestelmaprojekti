<?php
	include("connection.php");

	$id = htmlspecialchars($_POST["id"]);
	$name = htmlspecialchars($_POST["name"]);

	$sql = "UPDATE books SET name = :name WHERE id = :id";

	$query = $con->prepare($sql);
	$query->execute(array(':name' => $name, ':id' => $id));

	print ("<h2>Book name {$name} modified</h2>");
?>
<p><a href = "list.php">Back to booklist</a></p>

