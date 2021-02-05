<?php
error_reporting(0);
include_once("dbconnect.php");


$sql = "SELECT * FROM POST"; 
$result = $conn->query($sql);

if ($result->num_rows > 0) 
{
    $response["posts"]= array();
    while($row = $result -> fetch_assoc())
    {
        $postlist = array();
        $postlist[postid] = $row["POSTID"];
        $postlist[username] = $row["USERNAME"];
        $postlist[postimage] = $row["POSTIMAGE"];
        $postlist[postcaption] = $row["POSTCAPTION"];
        $postlist[postdate] = $row["POSTDATE"];
        $postlist[postcomment] = $row["POSTCOMMENT"];
        array_push($response["posts"], $postlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>
