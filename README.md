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

## Installation
Clone the repository:
```bash
git clone https://github.com/Sniks6/ipv64-update.git
cd ipv64-update
