import io
import pandas as pd
import requests
if 'data_loader' not in globals():
    from mage_ai.data_preparation.decorators import data_loader
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test

@data_loader
def load_data_from_api(*args, **kwargs):

    month = ['10', '11', '12']
    df = []

    for m in month:

        url = f'https://github.com/DataTalksClub/nyc-tlc-data/releases/download/green/green_tripdata_2020-{m}.csv.gz'
    
        taxi_dtypes = {
                        'VendorID': pd.Int64Dtype(),
                        'passenger_count': pd.Int64Dtype(),
                        'trip_distance': float,
                        'RatecodeID':pd.Int64Dtype(),
                        'store_and_fwd_flag':str,
                        'PULocationID':pd.Int64Dtype(),
                        'DOLocationID':pd.Int64Dtype(),
                        'payment_type': pd.Int64Dtype(),
                        'fare_amount': float,
                        'extra':float,
                        'mta_tax':float,
                        'tip_amount':float,
                        'tolls_amount':float,
                        'improvement_surcharge':float,
                        'total_amount':float,
                        'congestion_surcharge':float,
                        'trip_type' :float,
                        'ehail_fee' :float,
                                
                    }

        # native date parsing 
        parse_dates = ['lpep_pickup_datetime', 'lpep_dropoff_datetime']

        data = pd.read_csv(url, sep=',', compression='gzip', dtype=taxi_dtypes, parse_dates=parse_dates )
        
        data['month'] = m
        df.append(data)

    final_data = pd.concat(df, ignore_index=True)

    return final_data

@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'
	
import pandas as pd

if 'transformer' not in globals():
    from mage_ai.data_preparation.decorators import transformer
if 'test' not in globals():
    from mage_ai.data_preparation.decorators import test


@transformer
def transform(data, *args, **kwargs):

    data.columns = (data.columns
                .str.replace('(?<=[a-z])(?=[A-Z])', '_', regex=True)
                .str.lower()
             )
    data = data[(data['passenger_count'] > 0) & (data['trip_distance'] > 0)]
    data.lpep_pickup_datetime= pd.to_datetime(data.lpep_pickup_datetime)
    data.lpep_dropoff_datetime= pd.to_datetime(data.lpep_dropoff_datetime)

    
    data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date


    
    assert data['vendor_id'].isin([1, 2]).all(), "Assertion Error: vendor_id is not one of the existing values."
    assert (data['passenger_count'] > 0).all(), "Assertion Error: passenger_count is not greater than 0."
    assert (data['trip_distance'] > 0).all(), "Assertion Error: trip_distance is not greater than 0."

    

    return data


@test
def test_output(output, *args) -> None:
    """
    Template code for testing the output of the block.
    """
    assert output is not None, 'The output is undefined'


from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.postgres import Postgres
from pandas import DataFrame
from os import path
import pyarrow as pa
import pyarrow.parquet as pq
from pandas import DataFrame
import os



@data_exporter
def export_data_to_postgres(df: DataFrame, **kwargs) -> None:

    schema_name = 'mage'  # Specify the name of the schema to export data to
    table_name = 'green_taxi'  # Specify the name of the table to export data to
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'dev'

    with Postgres.with_config(ConfigFileLoader(config_path, config_profile)) as loader:
        loader.export(
            df,
            schema_name,
            table_name,
            index=False,  # Specifies whether to include index in exported table
            if_exists='replace',  # Specify resolution policy if table name already exists
        )



from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.google_cloud_storage import GoogleCloudStorage
from pandas import DataFrame
from os import path
import pyarrow as pa
import pyarrow.parquet as pq
from pandas import DataFrame
import os

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter

# update the variables below
os.environ['GOOGLE_APPLICATION_CREDENTIALS'] = '/home/src/lustrous-bonito-411623-3446485d5ecd.json'
project_id = 'lustrous-bonito-411623'
bucket_name = 'mage-zoomcamp-fad'
object_key = 'green_nyc_taxi_data.parquet'
table_name = 'green_taxi'
root_path = f'{bucket_name}/{table_name}'

@data_exporter
def export_data_to_google_cloud_storage(df: DataFrame, **kwargs) -> None:
    # creating a new date column from the existing datetime column
    
    table = pa.Table.from_pandas(df)

    gcs = pa.fs.GcsFileSystem()

    pq.write_to_dataset(
        table,
        root_path=root_path,
        partition_cols=['lpep_pickup_date'],
        filesystem=gcs
    )

--------------------------------------------------------------------------------------------------------



Question 1. Data Loading
Once the dataset is loaded, what's the shape of the data?

266,855 rows x 20 columns

Question 2. Data Transformation
Upon filtering the dataset where the passenger count is greater than 0 and the trip distance is greater than zero, how many rows are left?


139,370 rows

Question 3. Data Transformation
Which of the following creates a new column lpep_pickup_date by converting lpep_pickup_datetime to a date?


data['lpep_pickup_date'] = data['lpep_pickup_datetime'].dt.date

Question 4. Data Transformation
What are the existing values of VendorID in the dataset?

1 or 2

Question 5. Data Transformation
How many columns need to be renamed to snake case?


4

Question 6. Data Exporting
Once exported, how many partitions (folders) are present in Google Cloud?

96
