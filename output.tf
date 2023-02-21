output "user_pool" {
  description = "Cognito user pool"
  value       = aws_cognito_user_pool.create_user_pool
}

output "user_pool_arn" {
  description = "Cognito user pool ARN"
  value       = aws_cognito_user_pool.create_user_pool.arn
}

output "user_pool_id" {
  description = "Cognito user pool ID"
  value       = aws_cognito_user_pool.create_user_pool.id
}

output "user_pool_domain" {
  description = "Cognito user pool domain"
  value       = aws_cognito_user_pool.create_user_pool.domain
}

output "password_policy" {
  description = "Cognito password policy"
  value       = aws_cognito_user_pool.create_user_pool.password_policy
}

output "user_pool_clients" {
  description = "All clientes to Cognito user pool"
  value       = { for client in try(aws_cognito_user_pool_client.create_user_pool_clients, []) : client.name => merge(client, { client_secret = null }) }
}

output "cognito_user_pool_domain" {
  description = "Cognito user pool domain"
  value       = try(aws_cognito_user_pool_domain.create_user_pool_domain[0], null)
}

output "resources_servers" {
  description = "Cognito resources servers"
  value       = try(aws_cognito_resource_server.create_resources_servers, null)
}
