#!/usr/bin/env python3
"""Count ERROR lines in a log file. Config comes from environment variables."""
import os
import sys


def main() -> int:
    token = os.environ.get("API_TOKEN")
    log_file = os.environ.get("LOG_FILE")

    if not token:
        print("ERROR: API_TOKEN is not set", file=sys.stderr)
        return 1
    if not log_file:
        print("ERROR: LOG_FILE is not set", file=sys.stderr)
        return 1

    try:
        with open(log_file, "r", encoding="utf-8") as f:
            errors = sum(1 for line in f if "ERROR" in line)
    except FileNotFoundError:
        print(f"ERROR: log file not found: {log_file}", file=sys.stderr)
        return 1
    except PermissionError:
        print(f"ERROR: cannot read {log_file}", file=sys.stderr)
        return 1

    print(f"API token loaded (ends with ...{token[-4:]})")
    print(f"ERROR occurrences in {log_file}: {errors}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
