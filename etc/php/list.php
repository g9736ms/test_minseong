<?php include $_SERVER['DOCUMENT_ROOT']."/inc/top.php";
  include $_SERVER['DOCUMENT_ROOT']."/test_db.php";

?>
<body>
  <h1> 게시판입니다.</h1>
  <table width=800 border="1">
    <th width=50>No</th>
    <th width=500>제목</th>
    <th>작성자</th>
    <th>작성일</th>

  <?php
    $query = "select * from notice_board order by idx desc";
    $reult = mysqli_query($conn, $query);

    while($data = mysqli_fetch_array($reult)){
  ?>
  <tr>
    <td><?php echo $data['idx'] ?></td>
    <td><a href="view.php?idx=<?php echo $data['idx']?>"><?php echo $data['subject']?></a></td>
    <td><?php echo $data['name']?></td>
    <td><?php echo $data['regdate']?></td>
  </tr>
<?php } ?>
  </table>

  <a href="write.php">글쓰기</a>
</body>
