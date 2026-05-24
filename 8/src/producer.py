import argparse
import json
import time
import uuid

import redis


parser = argparse.ArgumentParser()
parser.add_argument("--host", default="localhost")
parser.add_argument("--port", type=int, default=6379)
parser.add_argument("--queue", default="jobs")
parser.add_argument("--count", type=int, default=5)
args = parser.parse_args()

r = redis.Redis(host=args.host, port=args.port, decode_responses=True)

for i in range(args.count):
    job = {
        "id": str(uuid.uuid4()),
        "type": "email",
        "payload": f"message-{i + 1}",
        "created_at": time.time(),
    }
    r.lpush(args.queue, json.dumps(job))
    print(f"produced {job['id']} {job['payload']}")
