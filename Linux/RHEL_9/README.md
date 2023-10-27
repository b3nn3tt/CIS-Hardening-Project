# Red Hat Enterprise Linux 9 CIS Hardening Automation Tool

This tool provides an automated approach to harden RHEL 9 systems in line with the CIS benchmarks. It allows users to apply security controls at various levels, ensuring systems are compliant and secure.

## Features
Profile Selection: Users can select between different CIS profile levels (L1 Server, L1 Workstation, L2 Server, L2 Workstation).
Logging: Comprehensive logs are generated, detailing which recommendations passed, failed, were skipped, or require manual intervention.
Modularity: Recommendations are executed via individual scripts, making it easy to update or modify specific controls.

## Features

- **Profile Selection**: Users can select between different CIS profile levels (L1 Server, L1 Workstation, L2 Server, L2 Workstation).
- **Logging**: Comprehensive logs are generated, detailing which recommendations passed, failed, were skipped, or require manual intervention.
- **Modularity**: Recommendations are executed via individual scripts, making it easy to update or modify specific controls.

## Prerequisites

- The tool must be run on a RHEL 9 system.
- Root privileges are required to execute the script.

## Usage

1. Clone the repository:
   ```bash
   git clone https://github.com/b3nn3tt/RHEL_9_CIS_Hardening.git
   cd RHEL_9_CIS_Hardening