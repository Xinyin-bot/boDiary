<?php

include_once("dbconnect.php");

$name = $_POST['name'];
$phone = $_POST['phone'];
$email = $_POST['email']; 
$password = sha1($_POST['password']);
$otp =rand(1000,9999);
$imagename = $_POST['imagename'];
$encoded_string = $_POST['encoded_string'];
$decoded_string = base64_decode($encoded_string);
$path = '../images/userimages/'.$imagename.'.jpg';
$is_written = file_put_contents($path, $decoded_string);


if ($is_written > 0) 
{
    $sqlregister = "INSERT INTO USER(NAME,EMAIL,PHONE,PASSWORD,IMAGE,OTP) VALUES('$name','$email','$phone','$password','$imagename','$otp')";
    if ($conn->query($sqlregister) === TRUE){
        sendEmail($otp,$email);
        echo "REGISTRATION SUCCESS!";
    }else{
        echo "REGISTRATION FAILED!";
    }
}else{
    echo "failed";
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

