<?php

include_once("dbconnect.php");

$name = $_POST['name'];
$phone = $_POST['phone'];
$email = $_POST['email'];
$password = $_POST['password'];
$otp =rand(1000,9999);

$sqlregister = "INSERT INTO USER(NAME,PHONE,EMAIL,PASSWORD,OTP) VALUES('$name','$phone','$email','$password','$otp')";

if($conn->query($sqlregister) === TRUE){
    sendEmail($otp,$email);
    echo "SUCCESS: REGISTER USER";
}else{
    echo "FAILED: REGISTER USER";
}

function sendEmail($otp,$email){
    $from = "noreply@BoDiary.com";
    $to = $email;
    $subject = "From BoDiary. Verify your account";
    $message = "BoDiary\n\nUse the following link to verify your account :"."\n http://sopmathpowy2.com/BoDiary/php/verify_account.php?email=".$email."&key=".$otp;
    $headers = "From:" . $from;
    mail($email,$subject,$message, $headers);
}

?>