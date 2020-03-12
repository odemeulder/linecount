import os
import store
from datetime import date

REPO = "https://github.com/odemeulder/ic"
REPO_DIR = "./data/repo"

def line_count_in_file(fname):
  i = 0
  with open(fname, 'rb') as f:
    for i, l in enumerate(f):
      pass
  return i + 1

def is_eligible(dentry):
  valid_exts = ["java", "py", "md", "cs", "aspx", "ashx"]
  for ext in valid_exts:
    if dentry.name.endswith(ext):
      return True
  return False

def line_count_in_dir(dname):
  lc = 0
  for entry in os.scandir(dname):
    if entry.is_file() and is_eligible(entry):
      lc += line_count_in_file(entry.path)
    elif entry.is_dir():
      lc += line_count_in_dir(entry)
  return lc

def pull_repo():
  os.system(f"if cd {REPO_DIR}; then git pull; else git clone {REPO} {REPO_DIR}; fi")

# def update_store(date, value):
#   s = store.load()
#   store.update(s, str(date), value)
#   store.save(s)

pull_repo()
lc = line_count_in_dir(REPO_DIR)
store.update(date.today(), lc)
print(lc)