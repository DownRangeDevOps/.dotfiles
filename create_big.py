import sys

from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext

glueContext = GlueContext(SparkContext.getOrCreate())

carbon = glueContext.create_dynamic_frame.from_catalog(
    database='dev-rds-science',
    table_name='science_factable_carbon')
