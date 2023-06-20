# tf-azure

In preparation for az 900 and az 104 certifications

- [X] Setup NAT Gateway for outbound connectivity instead of using Load Balancer public ip [Outbound Connections](https://learn.microsoft.com/en-us/azure/load-balancer/load-balancer-outbound-connections)
- [] Setup Azure Virtual Network Manager for hub and spoke topology [Doc](https://learn.microsoft.com/en-us/azure/virtual-network-manager/concept-connectivity-configuration)
- [] Setup private endpoints for ACR and Vault [Doc] (https://learn.microsoft.com/en-us/azure/private-link/private-endpoint-overview)
- [] Use spot instances or free B1s VMs [Doc] (https://learn.microsoft.com/en-us/azure/aks/spot-node-pool)
- [] Setup ACR repository for cache-through [Doc] (https://learn.microsoft.com/en-us/azure/container-registry/tutorial-registry-cache)

### Application gateway ingress controller

Requirements:
1) Assign read role for managed identity on resource group
2) Assign contributor role for managed identity on Application Gateway
