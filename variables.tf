variable "name" {
  description = "Cognito pool name"
  type        = string
}

variable "username_attributes" {
  description = "Whether email addresses or phone numbers can be specified as usernames when a user signs up, can be phone_number, email or preferred_username. Conflicts with alias_attributes"
  type        = list(string)
  default     = ["email"]
}

variable "alias_attributes" {
  description = "Attributes supported as an alias for this user pool, can be phone_number, email, or preferred_username. Conflicts with username_attributes"
  type        = list(string)
  default     = null
}

variable "auto_verified_attributes" {
  description = "Attributes to be auto-verified, can be email or phone_number"
  type        = list(string)
  default     = ["email"]
}

variable "case_sensitive_username" {
  description = "Configuration block for username if will be case sensitive or not"
  type        = bool
  default     = false
}

variable "pwd_minimum_length" {
  description = "Minimum length of the password policy that you have set"
  type        = number
  default     = 6
}

variable "pwd_require_lowercase" {
  description = "Whether you have required users to use at least one lowercase letter in their password"
  type        = bool
  default     = true
}

variable "pwd_require_numbers" {
  description = "Whether you have required users to use at least one number in their password"
  type        = bool
  default     = true
}

variable "pwd_require_symbols" {
  description = "Whether you have required users to use at least one symbol in their password"
  type        = bool
  default     = true
}

variable "pdw_require_uppercase" {
  description = "Whether you have required users to use at least one uppercase letter in their password"
  type        = bool
  default     = true
}

variable "pdw_temporary_password_validity_days" {
  description = "The password policy you have set, refers to the number of days a temporary password is valid. If the user does not sign-in during this time, their password will need to be reset by an administrator"
  type        = number
  default     = null
}

variable "user_pool_domain" {
  description = "For custom domains, this is the fully-qualified domain name, such as auth.example.com. For Amazon Cognito prefix domains, this is the prefix alone, such as auth"
  type        = string
  default     = null
}

variable "user_pool_domain_certificate_arn" {
  description = "The ARN of an ISSUED ACM certificate in us-east-1 for a custom domain"
  type        = string
  default     = null
}

variable "software_token_mfa_configuration" {
  description = "Configuration block for software token Mult-Factor Authentication (MFA) settings"
  type        = bool
  default     = null
}

variable "allow_admin_create_user" {
  description = "If true will be create admin user"
  type        = bool
  default     = false
}

variable "admin_email_subject" {
  description = "The subject for email messages"
  type        = string
  default     = "New account."
}

variable "admin_email_message" {
  description = "The message template for email messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively"
  type        = string
  default     = "Your username is {username} and your temporary password is '{####}'."
}

variable "admin_sms_message" {
  description = "The message template for SMS messages. Must contain {username} and {####} placeholders, for username and temporary password, respectively"
  type        = string
  default     = "Your username is {username} and your temporary password is '{####}'."
}

variable "add_ons_security_mode" {
  description = "Configuration block for user pool add-ons to enable user pool advanced security mode features, can be OFF, AUDIT or ENFORCED"
  type        = string
  default     = null
}

variable "sms_authentication_message" {
  description = "String representing the SMS authentication message. The Message must contain the {####} placeholder, which will be replaced with the code"
  type        = string
  default     = null
}

variable "mfa_configuration" {
  description = "Multi-Factor Authentication (MFA) configuration for the User Pool, can be ON or OFF. Defaults of OFF"
  type        = string
  default     = "OFF"
}

variable "deletion_protection" {
  description = "When active, DeletionProtection prevents accidental deletion of your user pool. Before you can delete a user pool that you have protected against deletion, you must deactivate this feature, can be ACTIVE or INACTIVE"
  type        = string
  default     = "INACTIVE"
}

variable "email_verification_subject" {
  description = "String representing the email verification subject. Conflicts with verification_message_template configuration block email_subject argument"
  type        = string
  default     = null
}

variable "email_verification_message" {
  description = "String representing the email verification message. Conflicts with verification_message_template configuration block email_message argument"
  type        = string
  default     = null
}

variable "sms_verification_message" {
  description = "String representing the SMS verification message. Conflicts with verification_message_template configuration block sms_message argument"
  type        = string
  default     = null
}

variable "ou_name" {
  description = "Organization unit name"
  type        = string
  default     = "no"
}

variable "use_tags_default" {
  description = "If true will be use the tags default"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags to Cognito"
  type        = map(any)
  default     = {}
}

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
  default = null
}

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
  default = null
}

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
  default = null
}

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
  default = null
}

variable "account_recovery_mechanisms" {
  description = "Configuration block to define which verified available method a user can use to recover their forgotten password"
  type = list(object({
    name     = string
    priority = number
  }))
  default = null
}

variable "device_configuration" {
  description = "Configuration block for the user pool's device tracking"
  type = object({
    device_only_remembered_on_user_prompt = bool
    challenge_required_on_new_device      = bool
  })
  default = null
}

variable "email_configuration" {
  description = "Configuration block for configuring email, doc: https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cognito_user_pool#email_configuration"
  type = object({
    configuration_set      = optional(string)
    email_sending_account  = optional(string)
    from_email_address     = optional(string)
    reply_to_email_address = optional(string)
    source_arn             = optional(string)
  })
  default = null
}

variable "sms_configuration" {
  description = "Configuration block for Short Message Service (SMS) settings. Detailed below. These settings apply to SMS user verification and SMS Multi-Factor Authentication (MFA)"
  type = object({
    external_id    = string
    sns_caller_arn = string
    sns_region     = optional(string)
  })
  default = null
}

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
  default = null
}
