provider "azurerm" {
  features {}

  subscription_id = "0821021b-f9a3-431b-ad44-913a7486e69e"  # ✅ Your Azure Subscription ID
}

# Resource Group
resource "azurerm_resource_group" "flask_rg" {
  name     = "flask-resource-group"
  location = "Central US"
}

# App Service Plan (F1 Free Tier)
resource "azurerm_service_plan" "flask_plan" {
  name                = "flask-app-service-plan"
  location            = azurerm_resource_group.flask_rg.location
  resource_group_name = azurerm_resource_group.flask_rg.name
  os_type             = "Linux"
  sku_name            = "F1"  # ✅ Ensure it's using the Free Tier
}

# Web App
resource "azurerm_linux_web_app" "flask_app" {
  name                = "flask-web-app-radhika1"
  location            = azurerm_resource_group.flask_rg.location
  resource_group_name = azurerm_resource_group.flask_rg.name
  service_plan_id     = azurerm_service_plan.flask_plan.id

  site_config {
    always_on = false  # ❌ Always ON is not supported for F1 Free Plan
    application_stack {
      python_version = "3.12"
    }
  }
}

# Output Web App URL
output "app_url" {
  value = "https://${azurerm_linux_web_app.flask_app.default_hostname}"
}
