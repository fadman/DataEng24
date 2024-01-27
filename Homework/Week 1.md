1.
Answer 1 --rm


2.
Answer 2 wheel 0.42.0


3.15612

SELECT * FROM public.green_taxi_trips


where TO_DATE(lpep_pickup_datetime,'YYYY-MM-DD') = '2019-09-18'
and TO_DATE(lpep_dropoff_datetime,'YYYY-MM-DD') = '2019-09-18'

4. "2019-09-26"	58759.9400000002

SELECT TO_DATE(lpep_pickup_datetime,'YYYY-MM-DD'), sum(trip_distance) FROM public.green_taxi_trips


group by TO_DATE(lpep_pickup_datetime,'YYYY-MM-DD')

order by sum(trip_distance) desc

5. "Brooklyn" "Manhattan" "Queens"

SELECT TO_DATE(lpep_pickup_datetime,'YYYY-MM-DD'), sum(total_amount), tz."Borough"
FROM public.green_taxi_trips as g

inner join public.taxi_zones tz on g."PULocationID" = tz."LocationID"
where TO_DATE(lpep_pickup_datetime,'YYYY-MM-DD') = '2019-09-18'

group by TO_DATE(lpep_pickup_datetime,'YYYY-MM-DD'), tz."Borough"

order by sum(total_amount) desc

6.
"Long Island City/Queens Plaza"

SELECT left(lpep_pickup_datetime,length(lpep_pickup_datetime) -12) , sum(tip_amount), tz."Zone" 
FROM public.green_taxi_trips g

inner join public.taxi_zones tz on g."DOLocationID" = tz."LocationID"

where left(lpep_pickup_datetime,length(lpep_pickup_datetime) -12) = '2019-09'
and "PULocationID" = 7

group by left(lpep_pickup_datetime,length(lpep_pickup_datetime) -12), tz."Zone" 

order by sum(tip_amount) desc
--------------------------------------------------------------------------------------------
if used timpstamp date instead of text use this istead:

SELECT date_trunc('month',lpep_pickup_datetime) , sum(tip_amount), tz."Zone" 
FROM public.green_taxi_trips g

inner join public.taxi_zones tz on g."DOLocationID" = tz."LocationID"

where date_trunc('month',lpep_pickup_datetime) = '2019-09-01 00:00:00'
and "PULocationID" = 7

group by date_trunc('month',lpep_pickup_datetime), tz."Zone" 

order by sum(tip_amount) desc

7.

terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create

Terraform will perform the following actions:

  # google_bigquery_dataset.demo_dataset will be created
  + resource "google_bigquery_dataset" "demo_dataset" {
      + creation_time              = (known after apply)
      + dataset_id                 = "demo_dataset"
      + default_collation          = (known after apply)
      + delete_contents_on_destroy = false
      + effective_labels           = (known after apply)
      + etag                       = (known after apply)
      + id                         = (known after apply)
      + is_case_insensitive        = (known after apply)
      + last_modified_time         = (known after apply)
      + location                   = "US"
      + max_time_travel_hours      = (known after apply)
      + project                    = "lustrous-bonito-411623"
      + self_link                  = (known after apply)
      + storage_billing_model      = (known after apply)
      + terraform_labels           = (known after apply)
    }

  # google_storage_bucket.demo-bucket will be created
  + resource "google_storage_bucket" "demo-bucket" {
      + effective_labels            = (known after apply)
      + force_destroy               = true
      + id                          = (known after apply)
      + location                    = "US"
      + name                        = "nyc-tl-data-fad2"
      + project                     = (known after apply)
      + public_access_prevention    = (known after apply)
      + rpo                         = (known after apply)
      + self_link                   = (known after apply)
      + storage_class               = "STANDARD"
      + terraform_labels            = (known after apply)
      + uniform_bucket_level_access = (known after apply)
      + url                         = (known after apply)

      + lifecycle_rule {
          + action {
              + type = "AbortIncompleteMultipartUpload"
            }
          + condition {
              + age                   = 1
              + matches_prefix        = []
              + matches_storage_class = []
              + matches_suffix        = []
              + with_state            = (known after apply)
            }
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

google_bigquery_dataset.demo_dataset: Creating...
google_storage_bucket.demo-bucket: Creating...
google_bigquery_dataset.demo_dataset: Creation complete after 0s [id=projects/lustrous-bonito-411623/datasets/demo_dataset]
google_storage_bucket.demo-bucket: Creation complete after 1s [id=nyc-tl-data-fad2]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.