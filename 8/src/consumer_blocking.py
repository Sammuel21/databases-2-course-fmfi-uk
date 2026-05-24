import argparse
import json

import redis


parser = argparse.ArgumentParser()
parser.add_argument("--host", default="localhost")
parser.add_argument("--port", type=int, default=6379)
parser.add_argument("--queue", default="jobs")
parser.add_argument("--limit", type=int, default=5)
parser.add_argument("--timeout", type=int, default=10)
args = parser.parse_args()

r = redis.Redis(host=args.host, port=args.port, decode_responses=True)
processed = 0

while processed < args.limit:
    item = r.brpop(args.queue, timeout=args.timeout)
    if item is None:
        print("timeout")
        break

    _, raw = item
    job = json.loads(raw)
    print(f"processed {job['id']} {job['payload']}")
    processed += 1
