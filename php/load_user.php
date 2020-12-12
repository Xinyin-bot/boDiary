<?php

error_reporting(0);
include_once("dbconnect.php");

$email = $_POST['email'];
$sql = "SELECT * FROM USER WHERE EMAIL = '$email'";
$result = $conn->query($sql);

if($result->num_rows > 0)
{
    $response["user"]= array();
    while($row = $result -> fetch_assoc())
    {
        $userlist = array();
        $userlist[name] = $row["NAME"];
        $userlist[phone] = $row["PHONE"];
        $userlist[email] = $row["EMAIL"];
        $userlist[password] = $row["PASSWORD"];
        $userlist[datereg] = $row["DATEREG"];
        $userlist[otp] = $row["OTP"];
        array_push($response["user"],$userlist);
    }
    echo json_encode($response);
}
else
{
    echo "No data";
}


?>