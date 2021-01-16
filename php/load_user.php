<?php
error_reporting(0);
include_once("dbconnect.php");

$sql = "SELECT * FROM USER";
$result = $conn->query($sql);

if($result->num_rows > 0)
{
    
    $response["users"]= array();
    while($row = $result -> fetch_assoc())
    {
        $userlist = array();
        $userlist[username] = $row["NAME"];
        $userlist[userphone] = $row["PHONE"];
        $userlist[useremail] = $row["EMAIL"];
        $userlist[userimage] = $row["IMAGE"];
        
        array_push($response["users"],$userlist);
    }
    echo json_encode($response);
}
else
{
    echo "nodata";
}


?>