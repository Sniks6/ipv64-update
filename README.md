# ipv64-update

PowerShell script for dynamically updating a DynDNS record at **ipv64.net**.

## Features

- Detects the current public IP address
- Optionally compares it with the existing DNS record
- Updates the DynDNS entry only if the IP has changed
- UTF-8 logging to a file

## Requirements

- Windows 10 / 11
- PowerShell 5.1 or PowerShell 7
- Internet connection
- DynDNS domain and token from ipv64.net

## Installation & Setup

1. Open the script file `ipv64-update.ps1` in a text editor.
2. Adjust the following configuration variables to match your setup:

```bash
$DOMAIN       = "YOUR_DOMAIN_NAME"
$DOMAIN_TOKEN = "YOUR_IPV64_TOKEN"
```

DOMAIN must be the DynDNS hostname registered at ipv64.net
DOMAIN_TOKEN is the update token provided by ipv64.net

1. Save the script after updating the values.