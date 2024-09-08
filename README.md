# Automated-data-pipeline-GCS-to-Snowflake
Automated pipeline to load orders data from Google Cloud Storage into Snowflake using SnowPipe and GCP Pub/Sub. It enables real-time data ingestion triggered by file uploads in GCS.



### Here are the steps for setting up an automated data pipeline from Google Cloud Storage to Snowflake:





### 1.Create Storage Integration in Snowflake:


Set up a storage integration in Snowflake to securely access the Google Cloud Storage (GCS) bucket. Configure permissions to allow Snowflake to read data from the bucket.

### 2.Create GCP Pub/Sub Topic:


Create a Pub/Sub topic in GCP to receive notifications when files are uploaded to the GCS bucket. This will act as a trigger for the data loading process.

### 3.Set Up Notification Subscription Between Bucket and Pub/Sub:


Link the GCS bucket to the Pub/Sub topic, so it sends notifications automatically when new files are added. This triggers the pipeline upon file upload.

### 4.Create Notification Integration in Snowflake:


Set up a notification integration in Snowflake to receive Pub/Sub notifications from GCP. This ensures Snowflake is alerted to new file uploads in real-time.

### 5.Create External Stage in Snowflake:


Define an external stage in Snowflake to connect to the GCS bucket. This allows Snowflake to read the uploaded files for processing.

### 6.Create SnowPipe to Load Data:


Configure SnowPipe to automatically load data from the external stage into the target table in Snowflake as soon as files are uploaded to the GCS bucket.







