# linux_reporting_logging
An html and plain text detailed report generator for linux systems

# Created on August 10th, 2024

This script collects system information on:
- Debian-based Linux distributions
- RHEL-based Linux distributions
- Generates HTML and log reports, and compares the two most recent reports for any differences. It also highlights changes in installed packages, kernel modules, error logs, and more.

## Prerequisites

- The script uses common utilities like `grep`, `awk`, `sed`, and package management commands (`apt`, `dnf`, `yum`, and `rpm`).
- Make sure the script is executable by running the following command:
  ```bash
  sudo chmod +x linux_system_report.sh
  ```
## Features
2. **System Uptime**: Shows the total time the system has been running
3. **CPU Load**: Displays the current CPU load on the system.
4. **Memory Usage**: Reports total, used, and available memory.
5. **Disk Usage**: Provides detailed disk usage by partitions.
6. **Network Information**: Shows network interfaces and their statuses.
7. **Last Logged-in Users**: Lists users who logged into the system.
8. **Running Processes**: Lists the top running processes consuming system resources.
9. **Services Status**: Shows the status of key services such as SSH, web servers, etc.
10. **Packages installed**: Shows apt, yum, dnf packages installed
11. **Counts amount installed**: Provides a count of the packages installed
12. **Error detection from logfiles**:
    - dmesg
    - jourlanctl
    - /var/log/auth.log
    - /var/log/yum.log
    - /var/log/secure
13. **Error amounts**: Counts amount of errors detected from log files
14. **HTML and plain text report generation**:
    - Creates an HTML report
    - Creates a log file plain text report
    - Creates a diffs report, which show deltas from the last, and the second last report.
15. **Opens the reports with google-chrome**

## How to Use the program

### 1. Clone the repo
### 2. Access the downloaded folder
```bash
cd linux-system-report
```
### 3. Provide read and write permissions
```bash
sudo chmod +rx linux_system_report_<version_number>.sh
```
### 4. Run the script with sudo
```bash
sudo bash linux_system_report.sh
```




