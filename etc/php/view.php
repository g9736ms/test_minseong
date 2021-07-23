<?php include $_SERVER['DOCUMENT_ROOT']."/inc/top.php";
  include $_SERVER['DOCUMENT_ROOT']."/test_db.php";
  $idx = $_GET['idx'];
  $idx = mysqli_real_escape_string($conn, $idx);

  $query = "select * from notice_board where idx='$idx'";
  $result = mysqli_query($conn, $query);
  $data = mysqli_fetch_array($result);

?>


<body>
  <form action="writepost.php" method="post">

    <table width=800 border="1" cellpadding=10>
      <tr>
        <th width=100>이름</th>
        <td><?php echo $data['name'] ?></td>
      </tr>

      <tr>
        <th>제목</th>

        <td><?php echo $data['subject'] ?></td>
      </tr>

      <tr>
        <th>내용</th>
        <td> <?php echo nl2br($data['memo']); ?>

        </td>
      </tr>

      <tr>
        <td colspan="2"> <!-- 두개 합침-->
          <div style="float:right;">
            <a href="del.php?idx=<?php echo $idx ?>" onclick="return confirm('정말삭제?');">삭제</a>
            <a href="write.php?idx=<?php echo $idx ?>"> 수정</a>
          </div>
          <a href="list.php"> 목록</a>
        </td>
      </tr>


    </table>
  </form>
</body>
