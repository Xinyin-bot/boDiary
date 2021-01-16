<?php
include_once("dbconnect.php");

$postid = $_POST['postid'];
$commentcaption = $_POST['commentcaption'];
$useremail = $_POST['useremail'];
$username = $_POST['username'];
$datecomment = $_POST['datecomment'];

$sqlregister = "INSERT INTO COMMENT(POSTID,CAPTION,USEREMAIL,USERNAME,DATECOMMENT) VALUES('$postid','$commentcaption','$useremail','$username','$datecomment')";

if ($conn->query($sqlregister) === TRUE) {

    echo "succes";
  
}else{
    echo "failed";
}

?>