[comment]: <> (please keep all comment items at the top of the markdown file)
[comment]: <> (please do not change the ***, as well as <div> placeholders for Note and Tip layout)
[comment]: <> (please keep the ### 1. and 2. titles as is for consistency across all demoguides)
[comment]: <> (section 1 provides a bullet list of resources + clarifying screenshots of the key resources details)
[comment]: <> (section 2 provides summarized step-by-step instructions on what to demo)


[comment]: <> (this is the section for the Note: item; please do not make any changes here)
***
### Azure PostgreSQL

<div style="background: lightgreen; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Note:** Below demo steps should be used **as a guideline** for doing your own demos. Please consider contributing to add additional demo steps.
</div>

[comment]: <> (this is the section for the Tip: item; consider adding a Tip, or remove the section between <div> and </div> if there is no tip)

<div style="background: lightblue; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Tip:** This template will build enviroment and load up it with data. Meanwhile to set up demos you might need to configure additional settings  mention in preparation steps: 

To connect and manage your PostgreSQL databases, you can use the following tools:

- [Azure Data Studio](https://learn.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) – A cross-platform database tool for data professionals.
- [PostgreSQL extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-ossdata.vscode-postgresql) – Enables PostgreSQL management and query capabilities directly in VS Code.
- 
</div>

***
### 1. What Resources are getting deployed
This scenario deploys a PostgreSQL environment to showcase key database features and functionality, along with its integration with Azure services such as Key Vault and OpenAI. 

Deployment includes:

* Azure Resource Group.
* Azure Keyvault
* Language cognitive service
* Azure Database for PostgreSQL flexible server in two instance
* Azure OpenAI service

![RG content](rg.png)

<!-- <img src="https://raw.githubusercontent.com/petender/azd-fdcdn/main/Demoguides/FDCDN/FDCDN_ResourceGroup_Overview.png" alt="FDCDN Resource Group" style="width:70%;">
<br></br> -->

### What can I demo from this scenario after deployment

This demo environment has been created to support the delivery of courses DP-3021 and AI-3019. It focuses on the deployment and configuration of PostgreSQL, as well as its integration with Azure AI services. The demos are organized to follow the sequence of modules in the corresponding classes.

## DP-3021. Configure and migrate to Azure Database for PostgreSQL 

### Demo #1 Provision PostgreSQL and Configure Server parameters

This demo introduces the provisioned services and demonstrates how to configure key PostgreSQL parameters.

The following parameters can be configured from the `Server parameters` blade in Azure PostgreSQL server:

* **work_mem**: Controls memory used for internal sort operations and hash tables before writing to temporary disk files.
* **maintenance_work_mem**: Allocated for maintenance operations such as VACUUM, CREATE INDEX, and ALTER TABLE.
* **autovacuum_work_mem**: Memory used by autovacuum processes to manage background cleanup tasks.
* **temp_buffers:** Defines the amount of memory used for temporary tables within each session.
* **effective_cache_size**: Provides a rough estimate of how much memory is available for disk caching by the operating system and PostgreSQL.

![Server parameters](params.png)

<!-- <img src="https://raw.githubusercontent.com/petender/azd-fdcdn/main/Demoguides/FDCDN/FDCDN_webappimages.png" alt="FDCDN Web App Images" style="width:70%;">
<br></br> -->

### Demo #2 Connectivity Tools

These tools provide a user-friendly interface for connecting, querying, and managing your PostgreSQL databases on Azure.

- [Azure Data Studio](https://learn.microsoft.com/en-us/sql/azure-data-studio/download-azure-data-studio) 
- [PostgreSQL extension for Visual Studio Code](https://marketplace.visualstudio.com/items?itemName=ms-ossdata.vscode-postgresql) 

When you run the **Azure Data Studio** you need create a connection to your server. Server name can be picked from the `Overview` page from the Azure Portal and user name is pgAdmin and password located in the Keyvault secret `pgAdmin`.

![Azure Data Studio](connect.png)

After connection to the server you should see the list of the databases and will be able to run the SQL query. 

![query](query.png)



## Demo 3: Explain statement

The `EXPLAIN` statement displays the execution plan for a query, helping you understand how PostgreSQL will execute it. This includes whether indexes are used, how tables are joined, and the estimated cost of the query.

**Common EXPLAIN options:**
- `ANALYZE`: Executes the query and provides actual run-time statistics in addition to the plan.
- `VERBOSE`: Shows additional information about the plan nodes.
- `COSTS`: Includes estimated startup and total costs for each plan node (enabled by default).
- `BUFFERS`: Reports buffer usage statistics (requires ANALYZE).
- `FORMAT`: Sets the output format (e.g., TEXT, XML, JSON, YAML).

You can demonstrate queries and result of from `Notebooks/explain.ipynb`.

![Explain Function](explain.png)

## Demo 4: Explain DB Roles in PostgreSQL

These roles help ensure secure and controlled access to your PostgreSQL server in Azure. The server already contains set of predefined roles like `pgAdmin` and `pg_database_owner`

Azure Database for PostgreSQL includes several built-in roles to help manage and secure your database:

- **azure_pg_admin**: This role is automatically granted to the server admin user. It provides elevated privileges for managing databases, roles, and most server-level operations, but does not have superuser rights for security reasons.
- **azuresu**: This is a special internal role used by the Azure platform for maintenance and management tasks. It is not assignable to users and is reserved for system operations.

You can demonstrate assigning and building custom roles from `Notebooks/roles.ipynb`.

![alt text](roles.png)


## Demo 5: Explain Stored Procedure and Functions

Azure Database for PostgreSQL supports both user-defined functions and stored procedures to help you encapsulate logic and reuse code in your database.

- **Create and use a function:**
  Functions in PostgreSQL allow you to encapsulate SQL logic that returns a value or a result set. You can create functions using PL/pgSQL or other supported languages. Functions are commonly used for calculations, data transformations, or reusable queries. 

- **Create a stored procedure:**
  Stored procedures are similar to functions but are designed for performing actions such as data modifications, transaction control, or complex business logic. Procedures can be called with the CALL statement and do not have to return a value.

You can find practical examples in `Notebooks/proc-func.ipynb`.

![Stored Procedures and Functions](proc-func.png)


## Demo 6: Explain replication 

For this demo you need to get connected for second DB provisioned above.

1. You have two servers provisioned. Publisher - your database server started with `main`. Subscriber is another instance started with `replica`. Update both servers with following Server parameters. 

  * `wal_level`= LOGICAL
  * `max_worker_processes` = 24

2. Save and Restart server.

3. Check the firewall settings. It should be opened to let the second server connects:

![firewall exception](networking.png)

4. Then you need to run queries from `Notebooks/pub-sub.sql` for appropriate databases.  Make sure you updated connection string in 
`CREATE SUBSCRIPTION sub CONNECTION ...`

5. When you create subscription you should see records inserted in the replica server equal to main server.

![Replica Table updated](replica.png)



## Demo 7: Explore metadata and VACUUM command

This demo explores PostgreSQL system catalogs and maintenance commands:

- **pg_catalog.pg_index**: View metadata about indexes defined on tables, including which columns are indexed and index properties.
- **pg_catalog.pg_stat_user_tables**: Monitor statistics for user tables, such as number of sequential and index scans, tuples inserted/updated/deleted, and autovacuum activity.
- **VACUUM**: Manually reclaims storage and optimizes tables by cleaning up dead tuples.
- **autovacuum**: An automatic background process that periodically runs VACUUM to maintain database health and performance.

You can find example queries and demonstrations in `Notebooks/metadata.ipynb` and related notebooks.

![vacuum](vacuum.png)


## Demo 8: Explore Query Store

This demo introduces the Query Store feature in Azure Database for PostgreSQL, which helps you monitor and analyze query performance over time. Query Store automatically captures query history, execution statistics, and wait events, making it easier to troubleshoot and optimize workloads.

Key views to explore:
- **query_store.query_texts_view**: Displays the text of queries captured by Query Store.
- **query_store.qs_view**: Shows aggregated statistics for queries, such as execution count, duration, and resource usage.
- **query_store.runtime_stats_view**: Provides runtime statistics for query executions.
- **query_store.pgms_wait_sampling_view**: Contains information about wait events sampled during query execution.

You can find example queries and practical usage in `Notebooks/QueryStore.ipynb`.

![Query Store](querystore.png)


## AI-3019. Build AI Apps with Azure Database for PostgreSQL

before run demo configure extensions with key and endpoint and location from your AI Language service 


```SQL
SELECT azure_ai.set_setting('azure_cognitive.endpoint','https://<YOUR_ENDPOINT>.cognitiveservices.azure.com/');
SELECT azure_ai.set_setting('azure_cognitive.subscription_key', '<YOUR_KEY>');
SELECT azure_ai.set_setting('azure_cognitive.region', '<YOUR_REGION>');
```

Another configuration should be added fro OPen AI model:

```SQL
SELECT azure_ai.set_setting('azure_openai.endpoint', '{endpoint}');
SELECT azure_ai.set_setting('azure_openai.subscription_key', '{api-key}');
```


### Demo 1: Explore the Azure AI Extension

This demo shows how to enable and configure the Azure AI and vector extensions in PostgreSQL using `psql` tool. You will connect to the database, install the required extensions, and set up API keys for Azure OpenAI and Language AI services. The demo also demonstrates creating vector embeddings and running sentiment analysis queries directly from PostgreSQL.

```SQL
SELECT
    id,
    comments,
    azure_cognitive.analyze_sentiment(comments, 'en') AS sentiment
FROM reviews
WHERE id IN (1, 3);
```

![sentiment](sentiment.png)


### Demo 2: Explore vector search.

This demo shows how to enhance a listings database with semantic search using Azure OpenAI embeddings. First, a new column is added to store 1,536-dimensional vectors generated from listing descriptions. These embeddings are created using the text-embedding-ada-002 model and stored in the database. A user can then input a natural language query, which is also converted into an embedding. Finally, a cosine similarity search retrieves listings with descriptions most semantically similar to the query, even if the exact words don’t match.

You can find practical examples in `Notebooks/vector-search.ipynb`.

![alt text](vectorsearch.png)

You also can create recommendation function to pull several listings based on a provided preferences.

You can find practical examples in `Notebooks/vector-store.ipynb`.

![alt text](vectorstore.png)

### Demo 3: Explore data summarization  

This task demonstrates how to generate two-sentence summaries of property descriptions using both extractive and abstractive summarization techniques. Additionally, the same summarization technique is applied to reviews, allowing users to quickly understand the overall sentiment and highlights of guest feedback.

You can find practical examples in `Notebooks/summarization.ipynb`.

![summarization](summarization.png)


### Demo 4: Explore sentiment analysis   

Following demonstrates how to analyze the sentiment of property reviews using Azure's analyze_sentiment() function. The sentiment result includes an overall label (e.g., positive, mixed, negative) and confidence scores for positive, neutral, and negative tones. For deeper insight, sentence-level sentiment analysis can be performed by splitting reviews into individual sentences. To optimize performance and reduce API costs, sentiment analysis is executed in batches and the results are stored in new columns in the reviews table. This allows the application to quickly access sentiment data without reprocessing, and enables queries such as identifying the most negative reviews for further analysis or moderation.

You can find practical examples in `Notebooks/sentiments.ipynb`.

![Sentiments](sentiments.png)


### Demo 5: Explore text analysis   

The workflow demonstrates how to use Azure Cognitive Services in PostgreSQL to extract key phrases, named entities, and personally identifiable information (PII) from listing descriptions. It involves creating new columns in the listings table to store extracted data, then populating them in batches using SQL UPDATE statements. Key phrases and entities are stored as arrays, while PII results include both redacted text and identified entities. The enriched data enables advanced querying, such as finding listings with specific features or redacting sensitive information.

You can find practical examples in `Notebooks/text.ipynb`.

![text](text.png)


### Demo 6: Explore Translate Text  








1. The 2nd scenario streams images from Azure Storage Account. Open the **%youralias%fdstorageaccount** Azure Storage Account.
2. Navigate to Storage Browser / Blob Containers / **Images** Container and show the 6 image files present.
3. Return to the web page itself, refresh the page in the browser, and click the 2nd button **Download from Azure Blob Storage**
4. Wait for the images to load, and note the loading time. This should be **faster** than the previous scenario.
5.  Navigate back to the Azure Portal, and open the **FrontDoor Resource** blade.
6.  From the **Overview** blade, explain the **Properties** such as Endpoint hostname, reflecting the name of the FrontDoor Service, the Origin Groups, pointing at the actual service(s) getting published through FrontDoor, and Routes, pointing at how FrontDoor is handling routing traffic.

<img src="https://raw.githubusercontent.com/petender/azd-fdcdn/main/Demoguides/FDCDN/FDCDN_frontdoor.png" alt="FDCDN Frontdoor" style="width:70%;">
<br></br>

1.  Select **Origin Groups / default-origin-group** to open its settings. In the Origin Groups blade, select **default-origin-group**.  
1. Explain this is where you configure the backend service getting published by FrontDoor. In our example, the Web App.
1. Click **close** and return to the FrontDoor main blade.
1. Select **Optimizations** from the Settings section. Highlight **Caching** is **Enabled**. 
1. Return to the web page itself, refresh the page in the browser, and click the 3rd button **Download from Azure CDN**
1. Wait for the images to load, which should be the **fastest** of all 3 scenarios.
1. Open a new browser tab, navigate to the web page again, and simulate all 3 download actions. This time, the **Azure CDN** should have an even shorter loading time as before, **confirming it's presented from cache**.

<div style="background: lightblue; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Tip:** As Azure CDN replicates content across different POPs (Points of Presence), involve your learners into the demo scenario, and ask them to share the loading times of the different scenarios. Especially when you have learners from other regions or geographies, the results are interesting to compare.
</div>


[comment]: <> (this is the closing section of the demo steps. Please do not change anything here to keep the layout consistant with the other demoguides.)
<br></br>
***
<div style="background: lightgray; 
            font-size: 14px; 
            color: black;
            padding: 5px; 
            border: 1px solid lightgray; 
            margin: 5px;">

**Note:** This is the end of the current demo guide instructions.
</div>




