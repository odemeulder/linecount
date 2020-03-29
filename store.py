import json
import boto3
from datetime import date

STORE_PATH = "./store/store.json"
BUCKET = "odm-linecount"
BUCKET_KEY = "store.json"
ENCODING = "UTF-8"

s3client = boto3.resource('s3')

def load(store_path = ""):
  content_object = s3client.Object(BUCKET, BUCKET_KEY)
  file_content = content_object.get()['Body']
  return json.load(file_content)

def save(store, store_path = ""):
  content_object = s3client.Object(BUCKET, BUCKET_KEY)
  content_object.put(
    Body=json.dumps(store)
  )


def update(key, value):
  s = load()
  s[str(key)] = value
  save(s)

print(date.today())