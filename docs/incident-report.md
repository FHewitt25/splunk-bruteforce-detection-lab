# Incident Report: Brute-Force Attempt Against Local Account (Lab Simulation)

| Field | Detail |
|---|---|
| Type | Credential attack, brute force (MITRE ATT&CK T1110) |
| Severity | Medium (lab: no real compromise) |
| Affected host | Endpoint 192.168.1.11 |
| Targeted account | SplunkVictim |
| Detected by | Splunk dashboard (Event ID 4625) and lockout alert (Event ID 4740) |
| Analyst | Fabian Hewitt |

## 1. Detection
The Attack Timeline panel showed a burst of failed logons (Event ID 4625) against a single account. Shortly after, Event ID 4740 (account locked out) triggered the real-time alert.

## 2. Triage
- Confirmed the events came from the monitored endpoint and targeted one account.
- Rapid, repeated failures followed by a lockout match a password-guessing pattern, not a user typo.
- No successful logon (Event ID 4624) for the account followed the failures, so no evidence of compromise.

## 3. Containment
- The lockout policy (3 attempts) stopped the attack automatically.
- Recommended next steps in production: verify with the account owner, block the source if external, reset the password, and check for the same source hitting other accounts (password spraying).

## 4. Eradication and recovery
Test account removed after the exercise (`Remove-LocalUser -Name "SplunkVictim"`).

## 5. Lessons learned
- Lockout alerts are high-signal; failed-logon counts give context.
- Tune thresholds to separate attacks from normal user mistakes.
- Add a correlation search for one source failing against many accounts.
