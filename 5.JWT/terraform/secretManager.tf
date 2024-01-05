resource "aws_secretsmanager_secret" "jwt-secret" {
	name = "jwt-secret"
}

resource "aws_secretsmanager_secret_version" "jwt-secret-version" {
	secret_id = aws_secretsmanager_secret.jwt-secret.id
	secret_string = jsonencode({"secretKey" = "getSecretSuccess!"})
}
