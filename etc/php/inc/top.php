<?php session_start(); ?>
<title>test4by4</title>
<header>4by4inc</header>
<table border="1" width='600'>
  <tr>
    <td>
      <a href="/"> 홈</a>
    </td>
    <td>
      <a href="/list.php"> 게시판</a>
    </td>
    <td>
      <?php
          if(!isset($_SESSION['user_id']) || !isset($_SESSION['user_name'])) {
              echo "<p>로그인을 해 주세요. <a href='/d/login.php'>[로그인]</a></p>";
          } else {
              $user_id = $_SESSION['user_id'];
              $user_name = $_SESSION['user_name'];
              echo "<p><strong>$user_name</strong>($user_id)님 환영합니다.";
              echo "<a href='/d/logout.php'>[로그아웃]</a></p>";
          }
      ?>
    </td>
  </tr>
</table>
