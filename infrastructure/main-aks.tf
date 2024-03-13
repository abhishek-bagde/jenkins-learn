resource "azurerm_kubernetes_cluster" "aks" {
  name                = var.aks_name
  location            = azurerm_resource_group.rgp.location
  resource_group_name = azurerm_resource_group.rgp.name
  dns_prefix          = "dns-${var.aks_name}"

  default_node_pool {
    name       = "agnetpool"
    node_count = 1
    vm_size    = "Standard_D2s_v3"
    os_sku     = "Ubuntu"
    temporary_name_for_rotation = "tempsys01"
  }

  identity {
    type = "SystemAssigned"
  }
}