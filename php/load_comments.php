<?php
error_reporting(0);
include_once("dbconnect.php");

$postid = $_POST['postid'];

$sql = "SELECT * FROM COMMENT WHERE POSTID = '$postid'"; 
$result = $conn->query($sql);

if ($result->num_rows > 0) {
    $response["comments"] = array();
    
    while ($row = $result ->fetch_assoc()){
        $commentlist = array();
        $commentlist[commentid] = $row["ID"];
        $commentlist[commentcaption] = $row["CAPTION"];
        $commentlist[useremail] = $row["USEREMAIL"];
        $commentlist[username] = $row["USERNAME"];
        $commentlist[datecomment] = $row["DATECOMMENT"];
        
        array_push($response["comments"], $commentlist);
    }
    echo json_encode($response);
}else{
    echo "nodata";
}
?>