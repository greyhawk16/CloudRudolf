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

if ($_SERVER["REQUEST_METHOD"] == "POST" && isset($_POST["login"])) {
    $username = $_POST["username"];
    $password = $_POST["password"];

    // 사용자 정보를 데이터베이스에서 가져오기
    $sql = "SELECT * FROM user WHERE id='$username'";
    $result = $conn->query($sql);

    if ($result->num_rows > 0) {
        $row = $result->fetch_assoc();
        if (password_verify($password, $row["password"])) {
            // 로그인 성공 시 세션 변수에 사용자 정보 저장
            $_SESSION["user_id"] = $row["id"];
            $message = "로그인 성공! 환영합니다, {$row["id"]}.";
          
            header("Location: index.php");
            exit();
        } else {
            $message = "비밀번호가 일치하지 않습니다.";
        }
    } else {
        $message = "사용자가 존재하지 않습니다.";
    }
}

$conn->close();
?>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>로그인 페이지</title>
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
            color:#007BFF;
        }
        .signup-link {
            text-align: center;
            margin-top: 10px;
        }
        .signup-link a {
            text-decoration: none;
            color: #007BFF;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <form action="" method="post">
        <h2>로그인</h2>
        <input type="text" name="username" placeholder="아이디">
        <input type="password" name="password" placeholder="비밀번호">
        <input type="submit" name="login" value="로그인">

        <div class="message"><?php echo $message; ?></div>

<div class="signup-link">
    계정이 없으신가요? <a href="signup.php">회원가입</a>
</div>

    </form>
 


</body>
</html>