#Requires -Version 5.1
Set-StrictMode -Version Latest

# =========================
# Configuration
# =========================
$DOMAIN       = "DEINE_URL"  # must be the DynDNS hostname registered at ipv64.net
$DOMAIN_TOKEN = "DEIN_TOKEN" # the update token provided by ipv64.net
$DYNDNS_PROVIDER = "https://ipv64.net/nic/update"

# Logging
$LOG_DIR  = "C:\Scripts"
$LOG_FILE = Join-Path $LOG_DIR "ipv64-update.log"
$MAX_LOG_BYTES = 5MB

# =========================
# Helper functions
# =========================
function Write-Log {
    param(
        [string]$Message,
        [ValidateSet("INFO","WARN","ERROR")]
        [string]$Level = "INFO"
    )
    $ts = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    Add-Content -Path $LOG_FILE -Value "$ts [$Level] $Message" -Encoding UTF8
}

function Rotate-LogIfNeeded {
    if (Test-Path $LOG_FILE) {
        if ((Get-Item $LOG_FILE).Length -ge $MAX_LOG_BYTES) {
            $stamp = Get-Date -Format "yyyyMMdd-HHmmss"
            Move-Item $LOG_FILE (Join-Path $LOG_DIR "ipv64-update.$stamp.log") -Force
        }
    }
}
# =========================
# Main
# =========================
New-Item -ItemType Directory -Path $LOG_DIR -Force | Out-Null
Rotate-LogIfNeeded

try {
    # Öffentliche IP holen
    $CURRENT_IP = (Invoke-RestMethod -Uri "https://checkip.amazonaws.com" -TimeoutSec 10).Trim()

    # DNS-IP holen
    $DNS_IP = $null
    try {
        $DNS_IP = (Resolve-DnsName $DOMAIN -Type A -ErrorAction Stop |
                   Select-Object -First 1 -ExpandProperty IPAddress)
    } catch {}

    Write-Log "Domain=$DOMAIN PublicIP=$CURRENT_IP DNSIP=$DNS_IP"

    # Vergleich + Update
    if ($CURRENT_IP -ne $DNS_IP) {
        Write-Log "IP changed → sending update"
        $URI = "${DYNDNS_PROVIDER}?key=${DOMAIN_TOKEN}&domain=${DOMAIN}&ip=${CURRENT_IP}"
        $RESPONSE = Invoke-RestMethod -Uri $URI -TimeoutSec 10
        Write-Log "Provider response: $RESPONSE"

        if ($RESPONSE -match 'badauth|nohost|abuse|badagent|!yours') {
            Write-Log "Provider returned error-like response: $RESPONSE" "WARN"
        }
    }
    else {
        Write-Log "No change -> no update needed"
    }

} catch {
    Write-Log ("FAILED: " + $_.Exception.Message) "ERROR"
    exit 1
}