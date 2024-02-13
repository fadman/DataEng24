Question 1
840,402 

Question 2
SELECT * FROM `lustrous-bonito-411623.ny_taxi.green_tripdata_2022_type` 
Bytes processed
0 MB


SELECT distinct PULocationID FROM `lustrous-bonito-411623.ny_taxi.green_tripdata_2022_type` 
Bytes processed
6.41 MB

Question 3
select count(*) from lustrous-bonito-411623.ny_taxi.green_tripdata_2022_type
where fare_amount = 0

1,622 

Question 4

Partition by lpep_pickup_datetime Cluster on PUlocationID

Question 5
SELECT distinct PULocationID FROM `lustrous-bonito-411623.ny_taxi.green_tripdata_2022_type` 
where TIMESTAMP_MICROS(CAST(lpep_pickup_datetime / 1000 AS INT64)) >= '2022-06-01' 
      and TIMESTAMP_MICROS(CAST(lpep_pickup_datetime / 1000 AS INT64)) <= '2022-06-30' 
	  
Bytes processed
12.82 MB
	  
SELECT distinct PULocationID FROM `lustrous-bonito-411623.ny_taxi.green_tripdata_2022_type_partitioned_clustered` 
where cleaned_pickup_datetime >= '2022-06-01' 
      and cleaned_pickup_datetime <= '2022-06-30'
	  
Bytes processed
1.09 MB

Question 6

GCP Bucket

Question 7 

False

Question 8

Bytes processed
0 B

Because it's in a Temporary table