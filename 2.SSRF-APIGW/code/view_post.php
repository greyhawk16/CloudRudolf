<!-- view_post.php --> <!DOCTYPE html> <html lang="en"> <head> 
    <meta charset="UTF-8"> 
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
     <title>게시글 보기</title> 
     <style> 
     body { font-family: 'Arial', sans-serif; display: flex; flex-direction: column; align-items: center; margin: 20px; } 
     h2 { color: #007BFF; margin-bottom: 10px; } 
     p { margin: 5px 0; } 
     .back-link { margin-top: 20px; } 
     .back-link a { text-decoration: none; color: #007BFF; font-weight: bold; } 
     .post-container { max-width: 800px; width: 100%; padding: 20px; background-color: #f5f5f5; border-radius: 4px; box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1); } 
     </style> </head>
      <body>
         <div class="post-container"> 
            <?php $servername = "localhost"; 
            $username = "guest"; 
            $password = "guest"; 
            $dbname = "web";
    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        die("데이터베이스 연결 실패: " . $conn->connect_error);
    }


    $post_id = isset($_GET['no']) ? $_GET['no'] : null;
    $return_url = isset($_GET['return']) ? $_GET['return'] : null;
if ($post_id) {

    $sql = "SELECT * FROM board WHERE no =$post_id";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();

        echo "<h2>{$row['title']}</h2>";
        echo "<p>작성자: {$row['id']}</p>";
        echo "<p>등록일: {$row['date']}</p>";
        echo "<p>내용: {$row['content']}</p>";
    }

    else {
        if($return_url)
        {
            header('Location: '. $return_url);
        }
        else
        {
            header('Location: '.$_SERVER['HTTP_REFERER']);
        }
    }

 }
    $conn->close();
    ?>
</div>

<div class="back-link">
    <a href="board.php">게시판으로 돌아가기</a>
</div>
</body> </html>