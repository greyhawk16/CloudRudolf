<!DOCTYPE html> <html> <head> <title>고객 게시판</title> 
<style> body { font-family: Arial, sans-serif; }
    .container {
        max-width: 800px;
        margin: 0 auto;
        padding: 20px;
    }

    h2 {
        margin-top: 20px;
        margin-bottom: 20px;
        text-align: center;
    }

    table {
        width: 100%;
        border-collapse: collapse;
        margin-bottom: 20px;
    }

    th, td {
        padding: 10px;
        text-align: left;
        border-bottom: 1px solid #ddd;
    }

    tr:hover {
        background-color: #f5f5f5;
    }

    .no-data {
        text-align: center;
        padding: 10px;
        color: red;
    }

    .btn-container {
        text-align: center;
    }

    .btn {
        display: inline-block;
        margin-right: 10px;
        padding: 10px 20px;
        background-color:grey;
        color: white;
        text-decoration: none;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }

    .btn:hover {
        background-color: skyblue;
    }
</style>
</head>
 <body> 
 <a href="index.php" class="btn">이전으로</a>
    <div class="container"> <h2>고객 게시판</h2> <table> <tr> <th>게시물 ID</th> <th>제목</th> <th>작성자</th> <th>등록일</th> </tr>


    <?php
    // 데이터베이스 연결
    $servername = "localhost";
    $username = "guest";
    $password = "guest";
    $dbname = "web";

    $conn = new mysqli($servername, $username, $password, $dbname);
    if ($conn->connect_error) {
        die("데이터베이스 연결 실패: " . $conn->connect_error);
    }

    // 게시물 목록 쿼리
    $sql = "SELECT * FROM board";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        // 게시물 목록 출력
        while ($row = $result->fetch_assoc()) {
            echo "<tr>
                <td>{$row['no']}</td>
                 <td><a href='view_post.php?no={$row['no']}&return={$_SERVER['HTTP_REFERER']}'>{$row['title']}</a></td>
                <td>{$row['id']}</td>
                <td>{$row['date']}</td>
            </tr>";
        }
    } else {
        echo "<tr><td colspan='3'>게시물이 없습니다.</td></tr>";
    }

    $conn->close();
    ?>
</table>
<a href="write.php" class="btn">글쓰기</a>
<a href="logout.php" class="btn">로그아웃</a>
</body>
</html>