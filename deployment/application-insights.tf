########################
# Application Insights
########################

resource "azurerm_log_analytics_workspace" "app_insights" {
  name                = var.prefix
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
}

resource "azurerm_application_insights" "app_insights" {
  name                = var.prefix
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = azurerm_resource_group.resource_group.location
  workspace_id        = azurerm_log_analytics_workspace.app_insights.id
  application_type    = "Node.JS"
}

resource "azurerm_application_insights_smart_detection_rule" "slow_page_load_time" {
  name                               = "Slow page load time"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = true
  send_emails_to_subscription_owners = false
  additional_email_recipients        = var.application_insights_smart_detection_email_recipients
}

resource "azurerm_application_insights_smart_detection_rule" "slow_server_response_time" {
  name                               = "Slow server response time"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = true
  send_emails_to_subscription_owners = false
  additional_email_recipients        = var.application_insights_smart_detection_email_recipients
}

resource "azurerm_application_insights_smart_detection_rule" "long_dependency_duration" {
  name                               = "Long dependency duration"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = true
  send_emails_to_subscription_owners = false
  additional_email_recipients        = var.application_insights_smart_detection_email_recipients
}

resource "azurerm_application_insights_smart_detection_rule" "degradation_server_response_time" {
  name                               = "Degradation in server response time"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = true
  send_emails_to_subscription_owners = false
  additional_email_recipients        = var.application_insights_smart_detection_email_recipients
}

resource "azurerm_application_insights_smart_detection_rule" "degradation_dependency_duration" {
  name                               = "Degradation in dependency duration"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = true
  send_emails_to_subscription_owners = false
  additional_email_recipients        = var.application_insights_smart_detection_email_recipients
}

resource "azurerm_application_insights_smart_detection_rule" "degradation_trace_severity_ratio" {
  name                               = "Degradation in trace severity ratio"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = false
}

resource "azurerm_application_insights_smart_detection_rule" "abnormal_rise_exception_volume" {
  name                               = "Abnormal rise in exception volume"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = false
}

resource "azurerm_application_insights_smart_detection_rule" "potential_memory_leak_detected" {
  name                               = "Potential memory leak detected"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = false
}

resource "azurerm_application_insights_smart_detection_rule" "potential_security_issue_detected" {
  name                               = "Potential security issue detected"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = false
}

resource "azurerm_application_insights_smart_detection_rule" "abnormal_rise_daily_data_volume" {
  name                               = "Abnormal rise in daily data volume"
  application_insights_id            = azurerm_application_insights.app_insights.id
  enabled                            = false
}
