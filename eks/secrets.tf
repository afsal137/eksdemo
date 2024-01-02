resource "kubernetes_secret" "db_secret" {
  metadata {
    name = "db-secret"
  }

  data = {
    POSTGRES_USER     = module.db.db_instance_username
    POSTGRES_PASSWORD = data.aws_secretsmanager_secret_version.password.secret_string
    POSTGRES_HOST     = module.db.db_instance_address
  }
}