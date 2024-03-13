resource "azurerm_container_registry" "acr" {
  name                = var.acr_name
  resource_group_name = azurerm_resource_group.rgp.name
  location            = azurerm_resource_group.rgp.location
  sku                 = "Standard"
}