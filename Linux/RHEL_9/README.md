# Red Hat Enterprise Linux 9 CIS Hardening Automation Tool

This tool provides an automated approach to harden RHEL 9 systems in line with the CIS benchmarks. It allows users to apply security controls at various levels, ensuring systems are compliant and secure.

![image](https://github.com/b3nn3tt/CIS-Hardening-Project/assets/42213764/a088f459-7ed5-4cf6-9960-358539bb8c41)

## Features

- **Profile Selection**: Users can select between different CIS profile levels:
   - L1 Server
   - L1 Workstation
   - L2 Server
   - L2 Workstation
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
2. Make the main script executable:
   ```bash
   chmod +x RHEL_9_CIS_Hardening.sh
3. Run the tool:
   ```bash
   sudo ./RHEL_9_CIS_Hardening.sh
4. Follow the on-screen prompts to select the desired profile level
5. Once the script completes, review the logs in the logs/ directory for details on the applied controls and any potential issues

## Contributing
Contributions are welcome! If you find a bug or have a suggestion for an improvement, please open an issue or submit a pull request.
