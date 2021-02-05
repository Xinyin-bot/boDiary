<?php

include_once("dbconnect.php");

$username = $_POST['username'];
$postimagename = $_POST['postimagename'];
$postcaption = $_POST['postcaption'];
$encoded_string = $_POST['encoded_string'];
$datepost = $_POST['datepost'];
$decoded_string = base64_decode($encoded_string);
$path = '../images/postimages/'.$postimagename.'.jpg';
$is_written = file_put_contents($path, $decoded_string);


if ($is_written > 0) 
{
    $sqlregister = "INSERT INTO POST(USERNAME,POSTIMAGE,POSTCAPTION,POSTDATE) VALUES('$username','$postimagename','$postcaption','$datepost')";
    if ($conn->query($sqlregister) === TRUE){
        echo "Success";
    }else{
        echo "POST UPLOAD FAILED!";
    }
}else{
    echo "POST UPLOAD FAILED!";
}

?>


