locals {
  tags_default = {
    "Name"       = var.name
    "tf-cognito" = var.name
    "tf-ou"      = var.ou_name
  }
}

resource "aws_cognito_user_pool" "create_user_pool" {
  name                       = var.name
  username_attributes        = var.username_attributes
  auto_verified_attributes   = var.auto_verified_attributes
  alias_attributes           = var.alias_attributes
  sms_authentication_message = var.sms_authentication_message
  mfa_configuration          = var.mfa_configuration
  deletion_protection        = var.deletion_protection
  email_verification_subject = var.email_verification_subject
  email_verification_message = var.email_verification_message
  sms_verification_message   = var.sms_verification_message
  tags                       = merge(var.tags, var.use_tags_default ? local.tags_default : {})

  username_configuration {
    case_sensitive = var.case_sensitive_username
  }

  password_policy {
    minimum_length                   = var.pwd_minimum_length
    require_lowercase                = var.pwd_require_lowercase
    require_numbers                  = var.pwd_require_numbers
    require_symbols                  = var.pwd_require_symbols
    require_uppercase                = var.pdw_require_uppercase
    temporary_password_validity_days = var.pdw_temporary_password_validity_days
  }

  verification_message_template {
    default_email_option  = var.verification_message_template.default_email_option
    email_subject         = var.verification_message_template.email_subject
    email_message         = var.verification_message_template.email_message
    email_message_by_link = var.verification_message_template.email_message_by_link
    email_subject_by_link = var.verification_message_template.email_subject_by_link
    sms_message           = var.verification_message_template.sms_message
  }

  admin_create_user_config {
    allow_admin_create_user_only = var.allow_admin_create_user

    invite_message_template {
      email_subject = var.admin_email_subject
      email_message = var.admin_email_message
      sms_message   = var.admin_sms_message
    }
  }

  dynamic "user_pool_add_ons" {
    for_each = var.add_ons_security_mode != null ? [1] : []

    content {
      advanced_security_mode = var.add_ons_security_mode
    }
  }

  dynamic "email_configuration" {
    for_each = var.email_configuration != null ? [1] : []

    content {
      configuration_set      = var.email_configuration.configuration_set
      email_sending_account  = var.email_configuration.email_sending_account
      from_email_address     = var.email_configuration.from_email_address
      reply_to_email_address = var.email_configuration.reply_to_email_address
      source_arn             = var.email_configuration.source_arn
    }
  }

  dynamic "sms_configuration" {
    for_each = var.sms_configuration != null ? [1] : []

    content {
      sns_caller_arn = var.sms_configuration.sns_caller_arn
      external_id    = var.sms_configuration.external_id
      sns_region     = var.sms_configuration.sns_region
    }
  }

  dynamic "schema" {
    for_each = var.schema_attributes
    iterator = item

    content {
      attribute_data_type      = item.value.attribute_data_type
      developer_only_attribute = item.value.developer_only_attribute
      mutable                  = item.value.mutable
      name                     = item.value.name
      required                 = item.value.required

      dynamic "string_attribute_constraints" {
        for_each = item.value.attribute_data_type == "String" ? [1] : []

        content {
          min_length = try(item.value.string_attribute_constraints.min_length, null)
          max_length = try(item.value.string_attribute_constraints.max_length, null)
        }
      }

      dynamic "number_attribute_constraints" {
        for_each = item.value.attribute_data_type == "Number" ? [1] : []

        content {
          min_value = try(item.value.number_attribute_constraints.min_value, null)
          max_value = try(item.value.number_attribute_constraints.max_value, null)
        }
      }
    }
  }

  dynamic "lambda_config" {
    for_each = var.lambda_config != null ? [1] : []

    content {
      create_auth_challenge          = var.lambda_config.create_auth_challenge
      custom_message                 = var.lambda_config.custom_message
      define_auth_challenge          = var.lambda_config.define_auth_challenge
      post_authentication            = var.lambda_config.post_authentication
      post_confirmation              = var.lambda_config.post_confirmation
      pre_authentication             = var.lambda_config.pre_authentication
      pre_sign_up                    = var.lambda_config.pre_sign_up
      pre_token_generation           = var.lambda_config.pre_token_generation
      user_migration                 = var.lambda_config.user_migration
      verify_auth_challenge_response = var.lambda_config.verify_auth_challenge_response
    }
  }

  dynamic "account_recovery_setting" {
    for_each = var.account_recovery_mechanisms != null ? [1] : []

    content {
      dynamic "recovery_mechanism" {
        for_each = var.account_recovery_mechanisms
        iterator = item

        content {
          name     = item.value.name
          priority = item.value.priority
        }
      }
    }
  }

  dynamic "device_configuration" {
    for_each = var.device_configuration != null ? [1] : []

    content {
      device_only_remembered_on_user_prompt = var.device_configuration.device_only_remembered_on_user_prompt
      challenge_required_on_new_device      = var.device_configuration.challenge_required_on_new_device
    }
  }

  dynamic "software_token_mfa_configuration" {
    for_each = var.software_token_mfa_configuration != null ? [1] : []

    content {
      enabled = var.software_token_mfa_configuration
    }
  }
}

resource "aws_cognito_user_pool_client" "create_user_pool_clients" {
  count = var.user_pool_clients != null ? length(var.user_pool_clients) : 0

  user_pool_id                         = aws_cognito_user_pool.create_user_pool.id
  name                                 = var.user_pool_clients[count.index].name
  generate_secret                      = var.user_pool_clients[count.index].generate_secret
  refresh_token_validity               = var.user_pool_clients[count.index].refresh_token_validity_days
  prevent_user_existence_errors        = var.user_pool_clients[count.index].prevent_user_existence_errors
  callback_urls                        = var.user_pool_clients[count.index].callback_urls
  allowed_oauth_flows_user_pool_client = var.user_pool_clients[count.index].allowed_oauth_flows_user_pool_client
  supported_identity_providers         = var.user_pool_clients[count.index].supported_identity_providers
  allowed_oauth_flows                  = var.user_pool_clients[count.index].allowed_oauth_flows
  allowed_oauth_scopes                 = var.user_pool_clients[count.index].allowed_oauth_scopes
  explicit_auth_flows                  = var.user_pool_clients[count.index].explicit_auth_flows
  default_redirect_uri                 = var.user_pool_clients[count.index].default_redirect_uri
  logout_urls                          = var.user_pool_clients[count.index].logout_urls
  read_attributes                      = var.user_pool_clients[count.index].read_attributes
  write_attributes                     = var.user_pool_clients[count.index].write_attributes
  access_token_validity                = var.user_pool_clients[count.index].access_token_validity_minutes
  id_token_validity                    = var.user_pool_clients[count.index].id_token_validity_minutes
  enable_token_revocation              = var.user_pool_clients[count.index].enable_token_revocation

  dynamic "token_validity_units" {
    for_each = var.user_pool_clients[count.index].client_token_validity != null ? var.user_pool_clients[count.index].client_token_validity : []
    iterator = item

    content {
      refresh_token = item.value.refresh_token_days
      access_token  = item.value.access_token_minutes
      id_token      = item.value.id_token_minutes
    }
  }
}

resource "aws_cognito_user_pool_domain" "create_user_pool_domain" {
  count = var.user_pool_domain != null ? 1 : 0

  domain          = var.user_pool_domain
  user_pool_id    = aws_cognito_user_pool.create_user_pool.id
  certificate_arn = var.user_pool_domain_certificate_arn
}

resource "aws_cognito_resource_server" "create_resources_servers" {
  count = var.resources_servers != null ? length(var.resources_servers) : 0

  name         = var.resources_servers[count.index].name
  identifier   = var.resources_servers[count.index].identifier
  user_pool_id = aws_cognito_user_pool.create_user_pool.id

  dynamic "scope" {
    for_each = var.resources_servers[count.index].scopes != null ? var.resources_servers[count.index].scopes : []
    iterator = item

    content {
      scope_name        = item.value.name
      scope_description = item.value.description
    }
  }
}
