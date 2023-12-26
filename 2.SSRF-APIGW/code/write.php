<?php
session_start();

$servername = "localhost";
$username = "guest";
$password = "guest";
$dbname = "web";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("데이터베이스 연결 실패: " . $conn->connect_error);
}

$message = "";

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["write"])) {
    $title = $_POST["title"];
    $content = $_POST["content"];
    $user_id = $_SESSION["user_id"];
    $current_time = time();  // 현재 시간을 초로 얻기

    // 글쓰기 정보를 데이터베이스에 추가
    $sql = "INSERT INTO board (title, content, id, date) VALUES ('$title', '$content', '$user_id', '$current_time')";

    if ($conn->query($sql) === TRUE) {
        $message = "게시물이 성공적으로 작성되었습니다.";
    } else {
        $message = "오류: " . $sql . "<br>" . $conn->error;
    }
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>글쓰기 페이지</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css">
    <style>
        body {
            background-color: #f6f6f6;
        }
        .container {
            margin-top: 50px;
        }
        .form-container {
            background-color: #fff;
            border: 1px solid #ddd;
            border-radius: 8px;
            padding: 20px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .message {
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-md-6">
                <div class="form-container">
                    <h2 class="text-center">글쓰기</h2>
                    <form action="" method="post">
                        <div class="form-group">
                            <label for="title">제목</label>
                            <input type="text" name="title" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="content">내용</label>
                            <textarea name="content" class="form-control" rows="5" required></textarea>
                        </div>
                        <button type="submit" name="write" class="btn btn-primary btn-block">글쓰기</button>
                    </form>
                    <div class="message text-center"><?php echo $message; ?></div>
                    <div class="text-center mt-3">
                        <a href="board.php" class="btn btn-secondary">게시판으로 돌아가기</a>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS 및 jQuery -->
    <script src="https://code.jquery.com/jquery-3.3.1.slim.min.js"></script>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.7/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/js/bootstrap.min.js"></script>
</body>
</html>
