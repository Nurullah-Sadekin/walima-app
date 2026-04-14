#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REQUESTS_FILE="${CURLS_FILE:-$SCRIPT_DIR/../api_services/curls.josn}"

format_output() {
  local body="$1"

  if command -v jq >/dev/null 2>&1; then
    if printf '%s\n' "$body" | jq . >/dev/null 2>&1; then
      printf '%s\n' "$body" | jq .
      return
    fi
  fi

  printf '%s\n' "$body"
}

usage() {
  cat <<'EOF'
Usage:
  ./scripts/api-test.sh list
  ./scripts/api-test.sh run <request_id_or_index>

Examples:
  ./scripts/api-test.sh list
  ./scripts/api-test.sh run plans
  ./scripts/api-test.sh run 2
EOF
}

require_cmd() {
  local name="$1"
  if ! command -v "$name" >/dev/null 2>&1; then
    echo "Error: required command not found: $name" >&2
    exit 1
  fi
}

resolve_placeholders() {
  local value="$1"
  local var_name=""
  local replacement=""

  while [[ "$value" =~ \{\{([A-Za-z_][A-Za-z0-9_]*)\}\} ]]; do
    var_name="${BASH_REMATCH[1]}"
    replacement="${!var_name:-}"
    if [[ -z "$replacement" ]]; then
      echo "Error: missing required environment variable: $var_name" >&2
      exit 1
    fi
    value="${value//\{\{$var_name\}\}/$replacement}"
  done

  printf '%s' "$value"
}

list_requests() {
  jq -r '.requests | to_entries[] | "\(.key + 1). \(.value.id) [\(.value.method // "GET")] \(.value.url)"' "$REQUESTS_FILE"
}

get_request_json() {
  local selector="$1"
  local request_json=""

  if [[ "$selector" =~ ^[0-9]+$ ]]; then
    request_json="$(jq -c --argjson idx "$((selector - 1))" '.requests[$idx]' "$REQUESTS_FILE")"
  else
    request_json="$(jq -c --arg id "$selector" '.requests[] | select(.id == $id)' "$REQUESTS_FILE" | head -n 1)"
  fi

  if [[ -z "$request_json" || "$request_json" == "null" ]]; then
    echo "Error: request not found: $selector" >&2
    echo "Available requests:" >&2
    list_requests >&2
    exit 1
  fi

  printf '%s' "$request_json"
}

run_request() {
  local selector="$1"
  local request_json=""
  local method=""
  local url=""
  local body_type="null"
  local body_payload=""
  local response_with_code=""
  local body=""
  local status_code=""
  local -a curl_cmd=()

  request_json="$(get_request_json "$selector")"
  method="$(jq -r '.method // "GET"' <<<"$request_json")"
  url="$(jq -r '.url // empty' <<<"$request_json")"

  if [[ -z "$url" ]]; then
    echo "Error: selected request has no url" >&2
    exit 1
  fi

  curl_cmd=(curl -sS -X "$method" "$url" -w $'\n%{http_code}')

  while IFS=$'\t' read -r header_key header_value; do
    header_value="$(resolve_placeholders "$header_value")"
    curl_cmd+=(-H "$header_key: $header_value")
  done < <(jq -r '.headers // {} | to_entries[] | "\(.key)\t\(.value)"' <<<"$request_json")

  body_type="$(jq -r 'if has("body") then (.body | type) else "null" end' <<<"$request_json")"
  if [[ "$body_type" == "string" ]]; then
    body_payload="$(jq -r '.body' <<<"$request_json")"
    curl_cmd+=(--data "$body_payload")
  elif [[ "$body_type" != "null" ]]; then
    body_payload="$(jq -c '.body' <<<"$request_json")"
    curl_cmd+=(--data "$body_payload")
  fi

  response_with_code="$("${curl_cmd[@]}")"

  body="${response_with_code%$'\n'*}"
  status_code="${response_with_code##*$'\n'}"

  if [[ "$status_code" =~ ^2[0-9][0-9]$ ]]; then
    format_output "$body"
    exit 0
  fi

  echo "Request failed with status $status_code" >&2
  format_output "$body" >&2
  exit 1
}

require_cmd curl
require_cmd jq

if [[ ! -f "$REQUESTS_FILE" ]]; then
  echo "Error: requests file not found: $REQUESTS_FILE" >&2
  exit 1
fi

command_name="${1:-list}"

case "$command_name" in
  list)
    list_requests
    ;;
  run)
    selector="${2:-}"
    if [[ -z "$selector" ]]; then
      echo "Error: missing request id or index" >&2
      usage
      exit 1
    fi
    run_request "$selector"
    ;;
  help|-h|--help)
    usage
    ;;
  *)
    echo "Error: unknown command: $command_name" >&2
    usage
    exit 1
    ;;
esac
