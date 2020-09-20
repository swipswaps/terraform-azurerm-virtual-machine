module "virtual-machine" {
  source  = "kumarvna/virtual-machine/azurerm"
  version = "2.0.0"

  # Resource Group, location, VNet and Subnet details
  resource_group_name  = "rg-hub-demo-internal-shared-westeurope-001"
  location             = "westeurope"
  virtual_network_name = "vnet-default-hub-westeurope"
  subnet_name          = "snet-management-default-hub-westeurope"
  virtual_machine_name = "vm-linux"

  # (Optional) To enable Azure Monitoring and install log analytics agents
  log_analytics_workspace_name = var.log_analytics_workspace_id
  hub_storage_account_name     = var.hub_storage_account_id

  # This module support multiple Pre-Defined Linux and Windows Distributions.
  # Linux images: ubuntu1804, ubuntu1604, centos75, centos77, centos81, coreos
  # Windows Images: windows2012r2dc, windows2016dc, windows2019dc, windows2016dccore
  # MSSQL 2017 images: mssql2017exp, mssql2017dev, mssql2017std, mssql2017ent
  # MSSQL 2019 images: mssql2019dev, mssql2019std, mssql2019ent
  # MSSQL 2019 Linux OS Images:
  # RHEL8 images: mssql2019ent-rhel8, mssql2019std-rhel8, mssql2019dev-rhel8
  # Ubuntu images: mssql2019ent-ubuntu1804, mssql2019std-ubuntu1804, mssql2019dev-ubuntu1804
  # Bring your own License (BOYL) images: mssql2019ent-byol, mssql2019std-byol
  os_flavor                  = "windows"
  windows_distribution_name  = "mssql2017std"
  virtual_machine_size       = "Standard_A2_v2"
  admin_username             = "azureadmin"
  admin_password             = "complex_password"
  instances_count            = 2
  enable_vm_availability_set = true

  # Network Seurity group port allow definitions for each Virtual Machine
  # NSG association to be added automatically for all network interfaces.
  # SSH port 22 and 3389 is exposed to the Internet recommended for only testing. 
  # For production environments, recommended to use a VPN or private connection.
  nsg_inbound_rules = [
    {
      name                   = "rdp"
      destination_port_range = "3389"
      source_address_prefix  = "*"
    },

    {
      name                   = "dbport"
      destination_port_range = "1443"
      source_address_prefix  = "*"
    },
  ]

  # Adding TAG's to your Azure resources (Required)
  # ProjectName and Env are already declared above, to use them here, create a varible. 
  tags = {
    ProjectName  = "demo-internal"
    Env          = "dev"
    Owner        = "user@example.com"
    BusinessUnit = "CORP"
    ServiceClass = "Gold"
  }
}
