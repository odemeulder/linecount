import json
import boto3
from datetime import date

STORE_PATH = "./store/store.json"
BUCKET = "odm_linecount"
BUCKET_KEY = "store.json"
ENCODING = "UTF-8"

s3client = boto3.resource('s3')

def load(store_path = ""):
  # if store_path == "":
  #   store_path = STORE_PATH
  # with open(store_path) as fp: 
  #   return json.load(fp) 
  content_object = s3client.Object(BUCKET, BUCKET_KEY)
  file_content = content_object.get()['Body'].read().decode(ENCODING)
  return json.load(file_content)

def save(store, store_path = ""):
  # if store_path == "":
  #   store_path = STORE_PATH
  # with open(store_path, 'w') as fp:
  #   json.dump(store, fp)
  content_object = s3client.Object(BUCKET, BUCKET_KEY)
  content_object.put(
    Body=(bytes(json.dump(store).encode(ENCODING)))
  )


def update(key, value):
  s = load()
  s[str(key)] = value
  save(s)

print(date.today())