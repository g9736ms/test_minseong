<?php

  error_reporting(1);
  ini_set("display_errors", 1);

  $conn = mysqli_connect("localhost","testuser","123456","member_test"); //연동시킴

  if(mysqli_connect_error()){
      echo "접속 오류가 있습니다.";
      echo mysqli_connect_error();
  };


?>
