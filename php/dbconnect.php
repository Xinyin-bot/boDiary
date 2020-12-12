<?php
$servername = "localhost";
$username   = "sopmathp_bodiaryadmin";
$password   = "HXY,(Qa^{3MkM8f";
$dbname     = "sopmathp_BoDiaryDatabase";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
   die("Connection failed: " . $conn->connect_error);
}
?>