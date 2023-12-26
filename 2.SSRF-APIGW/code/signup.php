<?php

$servername = "localhost";
$username = "guest";
$password = "guest";
$dbname = "web";

$conn = new mysqli($servername, $username, $password, $dbname);
if ($conn->connect_error) {
    die("데이터베이스 연결 실패: " . $conn->connect_error);
}

$message = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = $_POST["username"];
    $password = $_POST["password"];

    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    // 사용자 정보를 데이터베이스에 추가
    $sql = "INSERT INTO user (id, password) VALUES ('$username', '$hashedPassword')";

    if ($conn->query($sql) === TRUE)
    {
        $message = "회원가입이 성공적으로 완료되었습니다.";
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
    <title>회원가입 페이지</title>
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
            background-color: #f6f6f6;
        }
        form {
            width: 300px;
            border: 1px solid #ccc;
            padding: 16px;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        form h2 {
            text-align: center;
            margin-bottom: 20px;
            color: #333;
        }
        form input[type="text"],
        form input[type="password"] {
            width: 100%;
            padding: 8px;
            margin-bottom: 8px;
            box-sizing: border-box;
        }
        form input[type="submit"] {
            width: 100%;
            padding: 8px;
            background-color: #007BFF;
            color: #fff;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }
        .message {
            text-align: center;
            margin-top: 10px;
            color: #007BFF;
        }
        .login-link {
            text-align: center;
            margin-top: 10px;
        }
        .login-link a {
            text-decoration: none;
            color: #007BFF;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form action="" method="post">
        <h2>회원가입</h2>
        <input type="text" name="username" placeholder="아이디">
        <input type="password" name="password" placeholder="비밀번호">
        <input type="submit" value="회원가입">

        <div class="message"><?php echo $message; ?></div>

<p class="login-link">
    이미 계정이 있으신가요? </p>
    
    <p><a href="login.php">로그인 페이지로 돌아가기</a></p>

    </form>

  
</body>
</html>