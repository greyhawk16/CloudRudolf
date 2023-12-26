<?php
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
   
    $api_url = 'http://localhost/';

    $product_id = $_POST['product_id'];
    $url = $api_url . $product_id;

    
    $response = file_get_contents($url);

    echo $response;
}
?>
