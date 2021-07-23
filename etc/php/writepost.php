<?php include $_SERVER['DOCUMENT_ROOT']."/test_db.php";
  //포스트 방식으로 값 받아옴
  $name = $_POST['name'];
  $subject = $_POST['subject'];
  $memo = $_POST['memo'];
  $regdate = date("Y-m-d H:i:s");
  $ip = date("Y-m-d H:i:s");

  $idx = $_POST['idx'];
  //해킹 방지용으로  mysqli_real_escape_string(연결값, 변수); 입력해줌
  $name = mysqli_real_escape_string($conn, $name);
  $subject = mysqli_real_escape_string($conn, $subject);
  $memo = mysqli_real_escape_string($conn, $memo);
  $idx = mysqli_real_escape_string($conn, $idx);
  //제목 이 비워져 있을때
  if($subject==NULL)
  {
    echo "<script>alert('재목은 비울 수 없습니다.');";
    echo "window.location.replace('write.php');</script>";
    exit;
  }

  //수정 부분 idx 를 가지고 판단
  if($idx){
    $query = "update notice_board set name='$name',
    subject='$subject',
    memo='$memo'
    where idx='$idx' ";
    mysqli_query($conn, $query);

  }
  else{
  //SQL 접근 값 받아와 넣어줌
  $query = "insert into notice_board(name, subject, memo, regdate) VALUES ('$name','$subject','$memo','$regdate')";
  mysqli_query($conn, $query);
  }
?>

<script>
  location.href='list.php';
</script>
