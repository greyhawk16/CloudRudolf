<!DOCTYPE html>
<html lang="en">

<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>상품 선택</title>
  <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
  <style>
    body {
      font-family: 'Arial', sans-serif;
      background-color: #f8f9fa;
      padding: 20px;
      display: flex;
      justify-content: center;
      align-items: center;
      min-height: 100vh;
    }

    .product-container {
      background-color: #ffffff;
      padding: 20px;
      border-radius: 8px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
      width: 100%;
      max-width: 500px;
    }

    h2 {
      color: gray;
      margin-bottom: 20px;
      text-align: center;
    }

    .form-check label {
      margin-right: 20px;
    }

    input[type="submit"] {
      background-color: gray;
      color: #ffffff;
      padding: 10px 20px;
      border: none;
      border-radius: 4px;
      cursor: pointer;
      font-size: 16px;
      display: block;
      margin: 0 auto;
      transition: background-color 0.3s ease;
    }

    input[type="submit"]:hover {
      background-color: skyblue;
    }

    .customer-board-button {
      margin-top: 20px;
      display: flex;
      justify-content: center;
    }
  </style>
</head>

<body>
  <div class="product-container">
    <h2>대출 상품 조회</h2>
    <form method="POST" action="fetch_product.php">
      <div class="form-check">
        <input type="radio" id="product1" name="product_id" value="resource/product1.html" class="form-check-input">
        <label for="product1" class="form-check-label">상품 1</label>
      </div>
      <div class="form-check">
        <input type="radio" id="product2" name="product_id" value="resource/product2.html" class="form-check-input">
        <label for="product2" class="form-check-label">상품 2</label>
      </div>
      <div class="form-check">
        <input type="radio" id="product3" name="product_id" value="resource/product3.html" class="form-check-input">
        <label for="product3" class="form-check-label">상품 3</label>
      </div>
      <input type="submit" value="제출">
    </form>

    <div class="customer-board-button">
      <a href="board.php" class="btn btn-primary">고객 게시판</a>
    </div>

  </div>

  <script src="https://code.jquery.com/jquery-3.5.1.slim.min.js"></script>
  <script src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.5.2/dist/umd/popper.min.js"></script>
  <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</body>
</html>
