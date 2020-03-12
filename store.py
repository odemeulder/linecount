import json
from datetime import date

STORE_PATH = "./store/store.json"

def load(store_path = ""):
  if store_path == "":
    store_path = STORE_PATH
  with open(store_path) as fp: 
    return json.load(fp) 

def save(store, store_path = ""):
  if store_path == "":
    store_path = STORE_PATH
  with open(store_path, 'w') as fp:
    json.dump(store, fp)

def update(key, value):
  s = load(STORE_PATH)
  s[str(key)] = value
  save(s)

print(date.today())