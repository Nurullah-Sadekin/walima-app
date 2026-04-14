## Curl Runner Guide

Use this script to load curl definitions from api_services/curls.josn and run one request at a time.

### Script

./scripts/api-test.sh

### Add New Curl Into List

Use the new helper script to append one raw curl command into the request list file.

```bash
cat <<'EOF' | ./scripts/add_curl_into_list
curl -X 'GET' \
	'https://dev.walima.app/api/v1/payments/subscription' \
	-H 'accept: */*' \
	-H 'Authorization: Bearer your_token_here'
EOF
```

Optional: set custom id when adding.

```bash
cat raw_curl.txt | ./scripts/add_curl_into_list --id subscription
```

### Request Source

Requests are stored in api_services/curls.josn as a JSON list.

### Required Environment Variable

Set your bearer token before running:

```bash
export WALIMA_API_TOKEN="your_jwt_token_here"
```

### List Available Requests

```bash
./scripts/api-test.sh list
```

### Run One Request

```bash
./scripts/api-test.sh run plans
./scripts/api-test.sh run 2
```

### Behavior

- Runs only the selected request by id or index.
- Prints JSON response to terminal.
- Requires `jq` and `curl` to be installed.
- Exits with non-zero status and prints error response for non-2xx HTTP codes.
- Replaces placeholders like `{{WALIMA_API_TOKEN}}` from environment variables.
- New added requests auto-generate `id` from URL path when `--id` is not provided.
