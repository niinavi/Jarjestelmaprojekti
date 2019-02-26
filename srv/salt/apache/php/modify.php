<!DOCTYPE html>
<html>
  <head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>Update book</title>
  </head>
  <body>
	<h1>Update book</h1>
    <form action="modBook.php" method="post">
	<?php
	include("connection.php");
		
	$id = htmlspecialchars($_GET["id"]);

        $sql = "SELECT id, name
                FROM books
                WHERE id=(:id)";
	
	$query = $con->prepare($sql);
        $query->bindParam(':id', $id);
	$query->execute();

	$row = $query->fetch();
  	$name = $row["name"];

	echo " <p>Name: <br> <input type='text' name='name' value='${name}'></p>";
	echo " <input type='hidden' name='id' value='${id}'></p>";


	?>
      <p><input type="submit" value="Send"></p>
    </form>
  </body>
</html>

