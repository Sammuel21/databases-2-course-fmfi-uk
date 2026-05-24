import argparse
import csv
import json
import urllib.request
from pathlib import Path


def request(method, url, body=None):
    data = None
    headers = {}
    if body is not None:
        data = json.dumps(body).encode("utf-8")
        headers["Content-Type"] = "application/json"
    req = urllib.request.Request(url, data=data, headers=headers, method=method)
    with urllib.request.urlopen(req) as response:
        return response.read().decode("utf-8")


def parse_number(value, number_type):
    if value == "NA" or value == "":
        return None
    return number_type(value)


parser = argparse.ArgumentParser()
parser.add_argument("--es", default="http://localhost:9200")
parser.add_argument("--index", default="penguins")
parser.add_argument("--csv-url", default="https://raw.githubusercontent.com/mwaskom/seaborn-data/master/penguins.csv")
parser.add_argument("--csv-path", default="data/penguins.csv")
args = parser.parse_args()

csv_path = Path(args.csv_path)
csv_path.parent.mkdir(parents=True, exist_ok=True)

if not csv_path.exists():
    urllib.request.urlretrieve(args.csv_url, csv_path)

mapping = {
    "mappings": {
        "properties": {
            "species": {"type": "text", "fields": {"keyword": {"type": "keyword"}}},
            "island": {"type": "text", "fields": {"keyword": {"type": "keyword"}}},
            "sex": {"type": "keyword"},
            "year": {"type": "integer"},
            "bill_length_mm": {"type": "float"},
            "bill_depth_mm": {"type": "float"},
            "flipper_length_mm": {"type": "float"},
            "body_mass_g": {"type": "float"},
            "description": {"type": "text"},
        }
    }
}

try:
    request("DELETE", f"{args.es}/{args.index}")
except Exception:
    pass

request("PUT", f"{args.es}/{args.index}", mapping)

bulk_lines = []

with csv_path.open(newline="", encoding="utf-8") as f:
    reader = csv.DictReader(f)
    for i, row in enumerate(reader, start=1):
        doc = {
            "species": row["species"],
            "island": row["island"],
            "bill_length_mm": parse_number(row["bill_length_mm"], float),
            "bill_depth_mm": parse_number(row["bill_depth_mm"], float),
            "flipper_length_mm": parse_number(row["flipper_length_mm"], float),
            "body_mass_g": parse_number(row["body_mass_g"], float),
            "sex": None if row["sex"] in ("NA", "") else row["sex"],
            "year": parse_number(row.get("year", ""), int),
            "description": f"{row['species']} penguin from {row['island']} island",
        }
        bulk_lines.append(json.dumps({"index": {"_index": args.index, "_id": i}}))
        bulk_lines.append(json.dumps(doc))

bulk_body = "\n".join(bulk_lines) + "\n"
req = urllib.request.Request(
    f"{args.es}/_bulk",
    data=bulk_body.encode("utf-8"),
    headers={"Content-Type": "application/x-ndjson"},
    method="POST",
)

with urllib.request.urlopen(req) as response:
    result = json.loads(response.read().decode("utf-8"))

request("POST", f"{args.es}/{args.index}/_refresh")

if result.get("errors"):
    raise SystemExit("bulk import failed")

print(f"imported {len(bulk_lines) // 2} documents into {args.index}")
