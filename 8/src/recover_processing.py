import argparse

import redis


parser = argparse.ArgumentParser()
parser.add_argument("--host", default="localhost")
parser.add_argument("--port", type=int, default=6379)
parser.add_argument("--queue", default="jobs")
parser.add_argument("--processing", default="jobs:processing")
args = parser.parse_args()

r = redis.Redis(host=args.host, port=args.port, decode_responses=True)
moved = 0

while True:
    raw = r.rpoplpush(args.processing, args.queue)
    if raw is None:
        break
    moved += 1

print(f"moved {moved} jobs back to {args.queue}")
