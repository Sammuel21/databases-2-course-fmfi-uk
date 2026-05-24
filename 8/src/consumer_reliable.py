import argparse
import json
import sys
import time

import redis


parser = argparse.ArgumentParser()
parser.add_argument("--host", default="localhost")
parser.add_argument("--port", type=int, default=6379)
parser.add_argument("--queue", default="jobs")
parser.add_argument("--processing", default="jobs:processing")
parser.add_argument("--limit", type=int, default=5)
parser.add_argument("--timeout", type=int, default=10)
parser.add_argument("--fail-after-pop", action="store_true")
args = parser.parse_args()

r = redis.Redis(host=args.host, port=args.port, decode_responses=True)
processed = 0

while processed < args.limit:
    raw = r.brpoplpush(args.queue, args.processing, timeout=args.timeout)
    if raw is None:
        print("timeout")
        break

    job = json.loads(raw)
    print(f"received {job['id']} {job['payload']}")

    if args.fail_after_pop:
        print("simulated crash")
        sys.exit(1)

    time.sleep(0.5)
    r.lrem(args.processing, 1, raw)
    print(f"ack {job['id']}")
    processed += 1
