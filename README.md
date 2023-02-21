# AWS Cognito for multiples accounts and regions with Terraform module
* This module simplifies creating and configuring of a Cognito across multiple accounts and regions on AWS

* Is possible use this module with one region using the standard profile or multi account and regions using multiple profiles setting in the modules.

## Actions necessary to use this module:

* Create file versions.tf with the exemple code below:
```hcl
terraform {
  required_version = ">= 1.1.3"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 2.0"
    }
  }
}
```

* Criate file provider.tf with the exemple code below:
```hcl
provider "aws" {
  alias   = "alias_profile_a"
  region  = "us-east-1"
  profile = "my-profile"
}

provider "aws" {
  alias   = "alias_profile_b"
  region  = "us-east-2"
  profile = "my-profile"
}
```


## Features enable of Cognito configurations for this module:

- Cognito user pool
- Cognito user pool clients
- Cognito user pool domain
- Cognito resources servers

## Usage exemples

### Cognito basic configuration

```hcl
module "cognito-test" {
  source = "web-virtua-aws-multi-account-modules/cognito/aws"

  name             = "tf-cognito-test"
  user_pool_domain = "tf-cog-test-domain-name"

  verification_message_template = {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }

  schema_attributes = [
    {
      name                     = "email"
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = true
      required                 = true

      string_attribute_constraints = {
        min_length = 1
        max_length = 256
      }
    }
  ]

  account_recovery_mechanisms = [
    {
      name     = "verified_email"
      priority = 1
    }
  ]

  user_pool_clients = [
    {
      name = "tf-cognito-test-client-1"
      generate_secret                      = true
      refresh_token_validity               = 90
      prevent_user_existence_errors        = "ENABLED"
      callback_urls                        = ["https://localhost:8080"]
      allowed_oauth_flows_user_pool_client = true
      supported_identity_providers         = ["COGNITO"]
      allowed_oauth_flows                  = ["implicit"]
      allowed_oauth_scopes                 = ["email", "openid"]

      explicit_auth_flows = [
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_ADMIN_USER_PASSWORD_AUTH"
      ]
    }
  ]

  providers = {
    aws = aws.alias_profile_b
  }
}
```


## Variables

| Name | Type | Default | Required | Description | Options |
|------|-------------|------|---------|:--------:|:--------|
| name | `string` | `-` | yes | Cognito pool name | `-` |
| username_attributes | `list(string)` | `["email"]` | no | Whether email addresses or phone numbers can be specified as usernames when a user signs up, can be phone_number, email or preferred_username. Conflicts with alias_attributes | `*`email <br> `*`phone_number <br> `*`preferred_username |
| alias_attributes | `list(string)` | `null` | no | Attributes supported as an alias for this user pool, can be phone_number, email, or preferred_username. Conflicts with username_attributes | `*`email <br> `*`phone_number <br> `*`preferred_username |
| auto_verified_attributes | `list(string)` | `["email"]` | no | Attributes to be auto-verified, can be email or phone_number | `*`email <br> `*`phone_number |
| case_sensitive_username | `bool` | `false` | no | Configuration block for username if will be case sensitive or not | `*`false <br> `*`true |
| pwd_minimum_length | `number` | `6` | no | Minimum length of the password policy that you have set | `-` |
| pwd_require_lowercase | `bool` | `true` | no | Whether you have required users to use at least one lowercase letter in their password | `*`false <br> `*`true |
| pwd_require_numbers | `bool` | `true` | no | Whether you have required users to use at least one number in their password | `*`false <br> `*`true |
| pwd_require_symbols | `bool` | `true` | no | Whether you have required users to use at least one symbol in their password | `*`false <br> `*`true |
| pdw_require_uppercase | `bool` | `true` | no | Whether you have required users to use at least one uppercase letter in their password | `*`false <br> `*`true |
| pdw_temporary_password_validity_days | `number` | `null` | no | The password policy you have set, refers to the number of days a temporary password is valid. If the user does not sign-in during this time, their password will need to be reset by an administrator | `-` |
| user_pool_domain | `string` | `null` | no | For custom domains, this is the fully-qualified domain name, such as auth.example.com. For Amazon Cognito prefix domains, this is the prefix alone, such as auth | `-` |
| user_pool_domain_certificate_arn | `string` | `null` | no | The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain | `-` |
| software_token_mfa_configuration | `bool` | `null` | no | Configuration block for software token Mult-Factor Authentication (MFA) settings | `*`false <br> `*`true |
| allow_admin_create_user | `bool` | `false` | no | If true will be create admin user | `*`false <br> `*`true |
| admin_email_subject | `string` | `New account.` | no | The subject for email messages | `-` |
| admin_email_message | `string` | `Your username is {username} and your temporary password is '{####}'.` | no | The message template for email messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively | `-` |
| admin_sms_message | `string` | `Your username is {username} and your temporary password is '{####}'.` | no | The message template for SMS messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively | `-` |
| add_ons_security_mode | `string` | `null` | no | Configuration block for user pool add-ons to enable user pool advanced security mode features, can be OFF, AUDIT or ENFORCED | `*`OFF <br> `*`AUDIT <br> `*`ENFORCED |
| sms_authentication_message | `string` | `null` | no | String representing the SMS authentication message. The Message must contain the {####} placeholder, which will be replaced with the code | `-` |
| mfa_configuration | `string` | `null` | no | Multi-Factor Authentication (MFA) configuration for the User Pool, can be ON or OFF. Defaults of OFF | `*`ON <br> `*`OFF |
| deletion_protection | `string` | `INACTIVE` | no | When active, DeletionProtection prevents accidental deletion of your user pool. Before you can delete a user pool that you have protected against deletion, you must deactivate this feature, can be ACTIVE or INACTIVE | `*`ACTIVE <br> `*`INACTIVE |
| email_verification_subject | `string` | `null` | no | String representing the email verification subject. Conflicts with verification_message_template configuration block email_subject argument | `-` |
| email_verification_message | `string` | `null` | no | String representing the email verification message. Conflicts with verification_message_template configuration block email_message argument | `-` |
| sms_verification_message | `string` | `null` | no | String representing the SMS verification message. Conflicts with verification_message_template configuration block sms_message argument | `-` |
| use_tags_default | `bool` | `true` | no | If true will be use the tags default | `*`false <br> `*`true |
| ou_name | `string` | `no` | no | Organization unit name | `-` |
| tags | `map(any)` | `{}` | no | Tags to Cognito | `-` |
| verification_message_template | `object` | `null` | no | Representing the email verification message. Conflicts with verification_message_template configuration block email_message argument | `-` |
| schema_attributes | `list(object)` | `null` | no | List of configuration block for the schema attributes of a user pool. Schema attributes from the standard attribute set only need to be specified if they are different from the default configuration. Attributes can be added, but not modified or removed. Maximum of 50 attributes | `-` |
| user_pool_clients | `list(object)` | `null` | no | List of Cognito user pool clients | `-` |
| lambda_config | `object` | `null` | no | Configuration block for the AWS Lambda triggers associated with the user pool | `-` |
| account_recovery_mechanisms | `list(object)` | `null` | no | Configuration block to define which verified available method a user can use to recover their forgotten password | `-` |
| device_configuration | `object` | `null` | no | Configuration block for the user pool's device tracking | `-` |
| email_configuration | `object` | `null` | no | Configuration block for configuring email, doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool#email_configuration | `-` |
| sms_configuration | `object` | `null` | no | Configuration block for Short Message Service (SMS) settings. Detailed below. These settings apply to SMS user verification and SMS Multi-Factor Authentication (MFA) | `-` |
| resources_servers | `list(object)` | `null` | no | Configuration block to define the resources servers | `-` |

* Model of variable verification_message_template
```hcl
variable "verification_message_template" {
  description = "Representing the email verification message. Conflicts with verification_message_template configuration block email_message argument"
  type = object({
    default_email_option  = optional(string)
    email_subject         = optional(string)
    email_message         = optional(string)
    email_message_by_link = optional(string)
    email_subject_by_link = optional(string)
    sms_message           = optional(string)
  })
  default = {
    default_email_option = "CONFIRM_WITH_CODE"
    email_subject        = "Account Confirmation"
    email_message        = "Your confirmation code is {####}"
  }
}
```

* Model of variable schema_attributes
```hcl
variable "schema_attributes" {
  description = "List of configuration block for the schema attributes of a user pool. Schema attributes from the standard attribute set only need to be specified if they are different from the default configuration. Attributes can be added, but not modified or removed. Maximum of 50 attributes"
  type = list(object({
    name                     = string
    attribute_data_type      = string
    developer_only_attribute = optional(bool)
    mutable                  = optional(bool)
    required                 = optional(bool)
    number_attribute_constraints = optional(list(object({
      max_value = optional(string)
      min_value = optional(string)
    })))
    string_attribute_constraints = optional(object({
      max_length = optional(string)
      min_length = optional(string)
    }))
    number_attribute_constraints = optional(object({
      max_value = optional(number)
      min_value = optional(number)
    }))
  }))
  default = [
    {
      name                     = "email"
      attribute_data_type      = "String"
      developer_only_attribute = false
      mutable                  = true
      required                 = true

      string_attribute_constraints = {
        min_length = 1
        max_length = 256
      }
    }
  ]
}
```

* Model of variable user_pool_clients
```hcl
variable "user_pool_clients" {
  description = "List of Cognito user pool clients"
  type = list(object({
    name                                 = string
    generate_secret                      = optional(bool)
    prevent_user_existence_errors        = optional(string)
    callback_urls                        = optional(list(string))
    allowed_oauth_flows_user_pool_client = optional(bool)
    supported_identity_providers         = optional(list(string))
    allowed_oauth_flows                  = optional(list(string))
    allowed_oauth_scopes                 = optional(list(string))
    explicit_auth_flows                  = optional(list(string))
    default_redirect_uri                 = optional(string)
    logout_urls                          = optional(list(string))
    read_attributes                      = optional(list(string))
    write_attributes                     = optional(list(string))
    enable_token_revocation              = optional(bool)
    refresh_token_validity_days          = optional(number)
    access_token_validity_minutes        = optional(number)
    id_token_validity_minutes            = optional(number)
    client_token_validity = optional(list(object({
      refresh_token_days   = optional(string)
      access_token_minutes = optional(string)
      id_token_minutes     = optional(string)
    })))
  }))
  default = [
    {
      name = "tf-cognito-test-client-1"
      # user_pool_id                         = aws_cognito_user_pool.user_pool.id
      generate_secret                      = true
      refresh_token_validity               = 90
      prevent_user_existence_errors        = "ENABLED"
      callback_urls                        = ["https://localhost:8080"]
      allowed_oauth_flows_user_pool_client = true
      supported_identity_providers         = ["COGNITO"]
      allowed_oauth_flows                  = ["implicit"] # retorna JWT
      allowed_oauth_scopes                 = ["email", "openid"]

      explicit_auth_flows = [
        "ALLOW_REFRESH_TOKEN_AUTH",
        "ALLOW_USER_PASSWORD_AUTH",
        "ALLOW_ADMIN_USER_PASSWORD_AUTH"
      ]
    }
  ]
}
```

* Model of variable lambda_config
```hcl
variable "lambda_config" {
  description = "Configuration block for the AWS Lambda triggers associated with the user pool"
  type = object({
    create_auth_challenge          = optional(string)
    custom_message                 = optional(string)
    define_auth_challenge          = optional(string)
    post_authentication            = optional(string)
    post_confirmation              = optional(string)
    pre_authentication             = optional(string)
    pre_sign_up                    = optional(string)
    pre_token_generation           = optional(string)
    user_migration                 = optional(string)
    verify_auth_challenge_response = optional(string)
  })
  default = {}
}
```

* Model of variable account_recovery_mechanisms
```hcl
variable "account_recovery_mechanisms" {
  description = "Configuration block to define which verified available method a user can use to recover their forgotten password"
  type = list(object({
    name     = string
    priority = number
  }))
  default = [
    {
      name     = "verified_email"
      priority = 1
    }
  ]
}
```

* Model of variable device_configuration
```hcl
variable "device_configuration" {
  description = "Configuration block for the user pool's device tracking"
  type = object({
    device_only_remembered_on_user_prompt = bool
    challenge_required_on_new_device      = bool
  })
  default = {}
}
```

* Model of variable email_configuration
```hcl
variable "email_configuration" {
  description = "Configuration block for configuring email, doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool#email_configuration"
  type = object({
    configuration_set      = optional(string)
    email_sending_account  = optional(string)
    from_email_address     = optional(string)
    reply_to_email_address = optional(string)
    source_arn             = optional(string)
  })
  default = {}
}
```

* Model of variable sms_configuration
```hcl
variable "sms_configuration" {
  description = "Configuration block for Short Message Service (SMS) settings. Detailed below. These settings apply to SMS user verification and SMS Multi-Factor Authentication (MFA)"
  type = object({
    external_id    = string
    sns_caller_arn = string
    sns_region     = optional(string)
  })
  default = {}
}
```

* Model of variable resources_servers
```hcl
variable "resources_servers" {
  description = "Configuration block to define the resources servers"
  type = list(object({
    name       = string
    identifier = string
    scopes = optional(list(object({
      name        = string
      description = string
    })))
  }))
  default = [
    {
      name         = "test-name"
      identifier   = "identifier-test"
      scopes = [
        {
          name = "name"
          description = "description"
        }
      ]
    }
  ]
}
```


## Resources

| Name | Type |
|------|------|
| [aws_cognito_user_pool.create_user_pool](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool) | resource |
| [aws_cognito_user_pool_client.create_user_pool_clients](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_client) | resource |
| [aws_cognito_user_pool_domain.create_user_pool_domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool_domain) | resource |
| [aws_cognito_resource_server.create_resources_servers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_resource_server) | resource |

## Outputs

| Name | Description |
|------|-------------|
| `user_pool` | Cognito user pool |
| `user_pool_arn` | Cognito user pool ARN |
| `user_pool_id` | Cognito user pool ID |
| `user_pool_domain` | Cognito user pool domain |
| `password_policy` | Cognito password policy |
| `user_pool_clients` | All clientes to Cognito user pool |
| `cognito_user_pool_domain` | Cognito user pool domain |
| `resources_servers` | Cognito resources servers |
