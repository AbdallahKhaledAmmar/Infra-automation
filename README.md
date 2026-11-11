
# Automated Infrastructure Scripting & Secrets Hygiene

A small infrastructure automation project built with Bash, Python, Cron, and Git. It automates directory backups, monitors application logs, and demonstrates basic secrets management practices.

## Project Overview

This project includes:

- Automated backup of a web directory using Bash.
- Scheduled backup execution using Cron.
- Python script for parsing application logs and counting errors.
- Environment variables for configuration and sensitive values.
- Git ignore rules to prevent secrets and backup archives from being committed.
- Optional webhook notifications after successful backups.

## Project Structure

```text
infra-automation/
├── backup.sh
├── parse_logs.py
├── .env.example
├── .gitignore
├── cron.txt
├── README.md
├── data/
│   └── webroot/
│       └── index.html
└── sample.log
```

## Requirements

- Ubuntu Linux
- Bash
- Python 3
- Cron
- Git
- curl

## Setup

Install the required packages:

```bash
sudo apt update
sudo apt install -y cron curl python3 git
```

Clone the repository and enter the project directory.

Create your environment file:

```bash
cp .env.example .env
```

Edit `.env` and update the paths and configuration values according to your environment.

Set the correct permissions:

```bash
chmod 600 .env
chmod +x backup.sh
```

**Important:** The `.env` file contains local configuration and sensitive values. It is excluded from Git and should never be committed.

## Backup Automation

Run the backup script manually:

```bash
./backup.sh
```

The script creates a compressed archive of the configured source directory and stores it in the backup destination.

Backups are named using the current date:

```text
backup-YYYY-MM-DD.tar.gz
```

## Log Parsing

The Python script reads the configured log file and counts entries containing `ERROR`.

Run it with:

```bash
set -a
source .env
set +a
python3 parse_logs.py
```

## Cron Scheduling

The backup script can be scheduled to run automatically every day at midnight.

Add the following entry using:

```bash
crontab -e
```

```cron
0 0 * * * /home/pc/automation/backup.sh >> /home/pc/automation/logs/backup.log 2>&1
```

Update the path if your project directory is different.

## Webhook Notifications

The backup script supports optional webhook notifications using `curl`.

When `WEBHOOK_URL` is configured in `.env`, the script sends a JSON notification after creating a backup.

Example notification:

```json
{
  "text": "Backup OK: backup-2026-11-11.tar.gz"
}
```

The webhook URL is kept in `.env` and is never committed to the repository.

## Secrets Hygiene

The project uses `.gitignore` to exclude:

- `.env` files
- Backup archives
- Log files
- Python cache files

Verify that sensitive files are ignored:

```bash
git check-ignore -v .env
```

## Environment

Developed and tested on Ubuntu 24.04 running under WSL2.

This is a local learning project designed to demonstrate basic infrastructure automation and secrets hygiene.

