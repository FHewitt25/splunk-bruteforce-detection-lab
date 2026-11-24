# Troubleshooting Log: Universal Forwarder → Splunk Receiver

## Issue 1: searches returned zero results
- Check: `index=* | stats count by sourcetype` showed no `WinEventLog:Security`.
- Cause: `inputs.conf` changes were not applied.
- Fix: `Restart-Service SplunkForwarder`. Data appeared.

## Issue 2: wrong port in outputs.conf
- Check (on the forwarder):
  ```powershell
  $UF = "C:\Program Files\SplunkUniversalForwarder\bin\splunk.exe"
  & $UF btool outputs list --debug | Select-String "tcpout|server|disabled|defaultGroup"
  ```
- Cause: destination used port **8089** (management/REST API) instead of **9997** (data receiving).
- Fix: edit `etc\system\local\outputs.conf` (never the default copy), then `& $UF restart`.

## Issue 3: wrong destination IP
- Check: `Test-NetConnection -ComputerName 192.168.1.10 -Port 9997` from the forwarder.
- Cause: outputs.conf pointed to 192.168.1.1 (the gateway) instead of the receiver at 192.168.1.10.
- Fix: corrected the IP, restarted, re-verified with btool.

## Final validation
An open port only proves reachability. Confirmed the real connection in `splunkd.log`:
`Connected to idx=192.168.1.10:9997`, then confirmed events arriving in `index=main`.
