import argparse
import json
import time

import redis


parser = argparse.ArgumentParser()
parser.add_argument("--host", default="localhost")
parser.add_argument("--port", type=int, default=6379)
parser.add_argument("--queue", default="jobs")
parser.add_argument("--limit", type=int, default=5)
parser.add_argument("--sleep", type=float, default=1.0)
args = parser.parse_args()

r = redis.Redis(host=args.host, port=args.port, decode_responses=True)
processed = 0

while processed < args.limit:
    raw = r.rpop(args.queue)
    if raw is None:
        print("queue empty")
        time.sleep(args.sleep)
        continue

    job = json.loads(raw)
    print(f"processed {job['id']} {job['payload']}")
    processed += 1
