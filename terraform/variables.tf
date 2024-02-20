variable "credentials" {
  description = "My Credentials"
  default     = "./mfta7/my-creds.json"

}


variable "project" {
  description = "Project"
  default     = "lustrous-bonito-411623"
}

variable "region" {
  description = "Region"
  #Update the below to your desired region
  default     = "us-west2"
}

variable "location" {
  description = "Project Location"
  #Update the below to your desired location
  default     = "US"
}

variable "bq_dataset_name" {
  description = "My BigQuery Dataset Name"
  #Update the below to what you want your dataset to be called
  default     = "demo_dataset"
}

variable "gcs_bucket_name" {
  description = "My Storage Bucket Name"
  #Update the below to a unique bucket name
  default     = "nyc-tl-data-fad2"
}

variable "gcs_storage_class" {
  description = "Bucket Storage Class"
  default     = "STANDARD"
}