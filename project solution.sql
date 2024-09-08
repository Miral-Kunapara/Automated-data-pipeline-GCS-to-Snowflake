--create database
create database snowpipe_project;

--create table

create or replace table order_data_lz(
   order_id int,
   product varchar(20),
   quantity int,
   order_status varchar(30),
   order_date date
   );

--create a cloud storage integration in snowflake

create or replace storage integration gcs_bucket_read_int
    type  = external_stage
    storage_provider = gcs
    enabled  = true
    storage_allowed_locations  = ('gcs://snowpipe_raw_data_practice/');

-- Retrieve the cloud storage services account for snowflake account
desc storage integration gcs_bucket_read_int;

--service account information to connect with gcs(google colud storage)
--kzqf00000@gcpuscentral1-1dfa.iam.gserviceaccount.com


-- Stage means reference to a specific external location where data will arrive
create or replace stage snowpipe_stage
  url = 'gcs://snowpipe_raw_data_practice/'
  storage_integration = gcs_bucket_read_int;


--show stages
show stages;


list @snowpipe_stage;

-- create notification integration
create or replace notification integration notification_from_pubsub_int
 type = queue
 notification_provider = gcp_pubsub
 enabled = true
 gcp_pubsub_subscription_name = 'projects/astute-city-426410-k4/subscriptions/snowpipe_pubsub_topic';


 -- Describe integration
desc integration notification_from_pubsub_int;

--service account for pub-sub
kxqf00000@gcpuscentral1-1dfa.iam.gserviceaccount.com

-- Create Snow Pipe
Create or replace pipe gcs_to_snowflake_pipe
auto_ingest = true
integration = notification_from_pubsub_int
as
copy into order_data_lz
from @snowpipe_stage
file_format = (type = 'CSV');

-- Show pipes
show pipes;

-- Check the status of pipe
select system$pipe_status('gcs_to_snowflake_pipe');

-- Check the history of ingestion
Select * 
from table(information_schema.copy_history(table_name=>'order_data_lz', start_time=> dateadd(hours, -1, current_timestamp())));


--select data
select * from order_data_lz ;

-- Terminate a pipe
drop pipe gcs_snowpipe;


--task scheduling 

create or replace table completed_order_data_lz(
   order_id int,
   product varchar(20),
   quantity int,
   order_status varchar(30),
   order_date date
   );




--create task

create or replace task target_table_ingestion
WAREHOUSE = COMPUTE_WH
SCHEDULE  = 'using cron */2 * * * * UTC' -- every 2 min
as
insert into completed_order_data_lz select * from order_data_lz where order_status = 'Completed'

alter task target_table_ingestion resume;

alter task target_table_ingestion suspend;
select * from completed_order_data_lz;

drop task target_table_ingestion;

