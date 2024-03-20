# azure-functions-sample-project

## Requirements

Following applications available in path:
* [OpenJDK](https://jdk.java.net/21/) (v21 or lower)
* [Terraform](https://developer.hashicorp.com/terraform/install?product_intent=terraform) (V1.5.6 or higher)
* [Node.JS](https://nodejs.org/en/download) (v18)
* Typescript (npm install -g typescript)

## Configuration
Create file ```deployment\terraform.tfvars``` and set the following settings:
```
AZURE_TENANT_ID="<your_azure_tenant_id>"
AZURE_SUBSCRIPTION_ID="<your_azure_subscription_id>"
AZURE_CLIENT_ID="<your_azure_client_id>"
AZURE_CLIENT_SECRET="<your_azure_client_secret>"
prefix="<unique_prefix_for_your_resources>"
azure_location="<azure_region>"
```

## Deployment

1. Open windows command prompt
2. Change directory to root of this Git project
3. Execute: ```gradlew deploy```

