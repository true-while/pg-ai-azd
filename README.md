## Introduction to Azure PostgreSQL and AI

This repo contains a demo for an Azure App Service WebApp, Storage Account and Azure Front Door with CDN, allowing to showcase the caching functionality by displaying Seattle scenery images and showing the loading time for different back-ends. This scenario can be deployed to Azure using the [Azure Developer CLI - AZD](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/overview). 

💪 This template scenario is part of the larger **[Microsoft Trainer Demo Deploy Catalog](https://aka.ms/trainer-demo-deploy)**.

## ⬇️ Installation
- [Azure Developer CLI - AZD](https://learn.microsoft.com/en-us/azure/developer/azure-developer-cli/install-azd)
    - When installing AZD, the above the following tools will be installed on your machine as well, if not already installed:
        - [GitHub CLI](https://cli.github.com)
        - [Bicep CLI](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)
    - You need Owner or Contributor access permissions to an Azure Subscription to  deploy the scenario.

## 🚀 Deploying the scenario in 4 steps:

1. Create a new folder on your machine.
```
mkdir -p true-while/pg-ai-azd
```
2. Next, navigate to the new folder.
```
cd true-while/pg-ai-azd
```
3. Next, run `azd init` to initialize the deployment.
```
azd init -t true-while/pg-ai-azd
```
4. Last, run `azd up` to trigger an actual deployment.
```
azd up
```

⏩ Note: you can delete the deployed scenario from the Azure Portal, or by running ```azd down``` from within the initiated folder.

## What is the demo scenario about?

The demo scenario is covering classes

* DP-3021: Configure and migrate to Azure Database for PostgreSQL 
* AI-3019: Build AI Apps with Azure Database for PostgreSQL

This demonstration provides a comprehensive overview of how to connect, manage, and utilize Azure Database for PostgreSQL using modern tools and Azure services. It begins by introducing essential connectivity tools such as Azure Data Studio and the PostgreSQL extension for Visual Studio Code, which offer user-friendly interfaces for database management and query execution.

The demo then guides users through key PostgreSQL server configuration steps, connectivity setup, and practical usage scenarios. It covers advanced database features including query analysis with the EXPLAIN statement, role management, stored procedures, and replication between servers. Maintenance operations like VACUUM and metadata exploration are also demonstrated.

Further, the guide explores integration with Azure AI services, showcasing how to enable and use extensions for sentiment analysis, vector search, data summarization, text analysis, and language translation directly within PostgreSQL. Each step is supported by practical examples and visual aids, making it easy to follow and replicate in your own Azure environment.

Use the [demo guide](https://raw.githubusercontent.com/true-while/pg-ai-azd/refs/heads/main/Demoguides/demogide.md) for inspiration for your demo.


## 💭 Feedback and Contributing
Feel free to create issues for bugs, suggestions or Fork and create a PR with new demo scenarios or optimizations to the templates. 
If you like the scenario, consider giving a GitHub ⭐



