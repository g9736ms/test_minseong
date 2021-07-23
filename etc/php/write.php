<?php include $_SERVER['DOCUMENT_ROOT']."/inc/top.php";
  include $_SERVER['DOCUMENT_ROOT']."/test_db.php";

  $idx = $_GET['idx'];
  $idx = mysqli_real_escape_string($conn, $idx);
  $query = "select * from notice_board where idx='$idx'";
  $result = mysqli_query($conn, $query);
  $data = mysqli_fetch_array($result);

?>



<body>
  <!-- witepost.php포스트 방식으로 넘김-->
  <form action="writepost.php" method="post">
    <!-- idx 값을  input에 써서 넘겨주는데 hidden을 써서 안보임-->
    <input type="hidden" name="idx" value="<?php echo $idx ?>">
    <!-- 게시판 글쓰기 레이아웃 -->
    <table width=800 border="1" cellpadding=10> <!--폭 , 보드종류, 간격-->
      <tr>
        <th>이름</th>
        <td><input type="text" name="name" value="<?php echo $data['name'] ?>" ></td> <!--박스 만듬 이름은 name설정-->
      </tr>

      <tr>
        <th>제목</th>
        <!--//style="width:100% 는 박스 칸 최대로 넓힘-->
        <td><input type="text" name="subject" value="<?php echo $data['subject']?>" style="width:100%; "> </td>
      </tr>

      <tr>
        <th>내용</th>
        <td>
          <textarea name="memo"  style="width:100%; height:300px;"> <?php echo $data['memo']?> </textarea>
        </td>
      </tr>

      <tr>
        <td colspan="2"> <!-- 두개 합침-->
          <div style="text-align:center;">
              <input type="submit" value="저장">
          </div>
        </td>
      </tr>


    </table>
  </form>
</body>
