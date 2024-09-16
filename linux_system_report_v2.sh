#!/bin/bash

# Create directory if it doesn't exist
report_dir="system_info_reports"
mkdir -p "$report_dir"

# Define file paths with timestamp and format
timestamp=$(date +"%Y_%m_%d_%H_%M_%S")
log_file="${report_dir}/system_info_${timestamp}.log"
html_file="${report_dir}/system_info_report_${timestamp}.html"

# Date format
current_date=$(date +"%Y-%m-%d %H:%M:%S")

# Extract Name and Version from /etc/os-release
os_name=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
os_version=$(grep '^VERSION=' /etc/os-release | cut -d= -f2 | tr -d '"')
os_title="${os_name} - ${os_version}"

# Determine distribution color and style
case "$os_name" in
    "Ubuntu")
        color_title="#FF6F00" # Fluorescent orange
        color_footer="#FF6F00" # Fluorescent orange
        ;;
    "RHEL"|"Red Hat")
        color_title="#C8102E" # Red
        color_footer="#C8102E" # Red
        ;;
    "AlmaLinux")
        color_title="#005F73" # Cool blue
        color_footer="#005F73" # Cool blue
        ;;
    "Linux Mint")
        color_title="#3C763D" # Mate green
        color_footer="#3C763D" # Mate green
        ;;
    "Debian")
        color_title="#0082FC" # Cool light blue
        color_footer="#0082FC" # Cool light blue
        ;;
    "Fedora")
        color_title="#1D3C6F" # Fedora blue
        color_footer="#1D3C6F" # Fedora blue
        ;;
    "openSUSE")
        color_title="#00A300" # openSUSE green
        color_footer="#00A300" # openSUSE green
        ;;
    "Arch Linux")
        color_title="#1793D1" # Arch blue
        color_footer="#1793D1" # Arch blue
        ;;
    "Manjaro")
        color_title="#3BCEAC" # Manjaro green
        color_footer="#3BCEAC" # Manjaro green
        ;;
    *)
        color_title="#00Aaff" # Default blue
        color_footer="#00Aaff" # Default blue
        ;;
esac

# Function to execute commands and log output with separators
execute_command() {
    local command="$1"
    local description="$2"
    local output=$(eval "$command")

    # Log command description and output to HTML file
    echo "<h3>$description</h3>" >> "$html_file"
    echo "<pre>$output</pre>" >> "$html_file"

    # Log command description and output to log file with separators
    echo "--------------------------------------------------------------------------------------------------------" >> "$log_file"
    echo "$current_date - $description" >> "$log_file"
    echo "$output" >> "$log_file"
    echo "--------------------------------------------------------------------------------------------------------" >> "$log_file"
}

# Function to execute commands and log errors with red borders
execute_error_command() {
    local command="$1"
    local description="$2"
    local output=$(eval "$command" 2>&1) # Capture both stdout and stderr

    # Check if output contains errors
    if echo "$output" | grep -i "error\|fail\|warn" > /dev/null; then
        # Log error description and output to HTML file
        echo "<h3 class='error-section'>$description</h3>" >> "$html_file"
        echo "<pre>$output</pre>" >> "$html_file"

        # Log error description and output to log file with separators
        echo "--------------------------------------------------------------------------------------------------------" >> "$log_file"
        echo "$current_date - ERROR: $description" >> "$log_file"
        echo "$output" >> "$log_file"
        echo "--------------------------------------------------------------------------------------------------------" >> "$log_file"
    fi
}

# Create or clear the log and HTML files
echo "Log created on $current_date" > "$log_file"
cat <<EOF > "$html_file"
<html>
<head>
    <title>System Info Report</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            line-height: 1.6;
            margin: 0;
            padding: 0;
            background-color: #1e1e1e;
            color: #f4f4f4;
        }
        h1 {
            color: $color_title;
            text-align: center;
            font-size: 3em;
            margin: 20px;
        }
        h3 {
            color: #ffffff;
            background-color: #333;
            padding: 15px;
            margin: 10px 0;
            border-left: 10px solid $color_title;
            border-right: 10px solid $color_title;
            border-radius: 5px;
        }
        .error-section {
            color: #ffffff;
            background-color: #333;
            padding: 15px;
            margin: 10px 0;
            border-left: 15px solid red;
            border-right: 15px solid red;
            border-radius: 5px;
        }
        .error-count { color: red; font-weight: bold; text-align: center; display: block; }
        pre {
            background-color: #000;
            color: #f4f4f4;
            border: 1px solid #444;
            padding: 15px;
            overflow: auto;
            border-radius: 5px;
            white-space: pre-wrap;
            word-wrap: break-word;
        }
        .container {
            width: 95%;
            margin: 20px auto;
            background: #2e2e2e;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 15px rgba(0, 0, 0, 0.5);
        }
        .section {
            margin-bottom: 20px;
            padding: 10px;
            border-radius: 5px;
        }
        .section:nth-child(odd) {
            background-color: #3c3c3c;
        }
        .section:nth-child(even) {
            background-color: #4a4a4a;
        }
        p {
            font-size: 1.1em;
            margin: 10px 0;
        }
        .footer {
            text-align: center;
            margin-top: 20px;
            font-size: 1.1em;
            color: #aaa;
        }
        .highlight {
            background-color: $color_footer;
            color: #000000;
            padding: 10px;
            border-radius: 5px;
            margin: 10px 0;
            font-size: 1.2em;
            text-align: center;
            text-shadow: 1px 1px 2px #000;
            box-shadow: 0px 0px 10px $color_footer;
        }
        .timestamp {
            background-color: $color_title;
            color: #fff;
            padding: 15px;
            border-radius: 5px;
            font-size: 1.5em;
            margin-top: 20px;
            text-align: center;
            text-shadow: 1px 1px 2px #000;
            box-shadow: 0px 0px 10px $color_title;
        }
        .kernel-highlight {
            background-color: $color_footer;
            color: #000000;
            padding: 5px;
            border-radius: 5px;
            font-weight: bold;
        }
        .footer-highlight {
            background-color: $color_footer;
            color: #000;
            padding: 15px;
            border-radius: 5px;
            font-size: 1.3em;
            text-align: center;
            text-shadow: 1px 1px 2px #000;
            box-shadow: 0px 0px 10px $color_footer;
        }
        .code-block {
            display: inline-block;
            padding: 10px;
            border: 1px solid #ccc;
            background-color: #f5f5f5;
            font-family: monospace;
            border-radius: 4px;
            word-wrap: break-word;
            white-space: pre-wrap;
        }
        .kernel-highlight {
            display: inline-block;
            padding: 5px;
            font-size: 16px;
            line-height: 1.5;
        }
        .kernel-highlight::before {
            content: "Running kernel: ";
        }
        .kernel-highlight span.variable {
            color: #39FF14; /* Fluorescent green */
            font-weight: bold;
        }
        .report-title {
            font-size: 2.5em;
            font-weight: bold;
            color: $color_title;
            background-color: #333;
            text-align: center;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.7);
            margin-top: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="report-title">$os_title - Linux System Information Report</div>
        <p class="timestamp">Report Start timestamp: $current_date</p>
EOF

# Execute commands and append to HTML

# Uptime details command
uptime_details_command=$(cat <<- EOM
echo "System Uptime - Human-readable format: \$(uptime --pretty)"
echo "System Uptime - Booted since: \$(uptime --since)"
echo "System Uptime - Standard format: \$(uptime)"
EOM
)

# Main script execution
echo
date
echo
echo "Starting Linux system detailed report script..."
echo
cat /etc/os-release
echo
hostnamectl
echo
echo "Displaying system uptime details..."
echo
uptime -p
echo
echo "System is up since: " $(uptime -s -p)
echo
execute_command "$uptime_details_command" "System Uptime Details"

execute_command "hostnamectl" "Hostname Information"
execute_command "cat /etc/os-release" "OS Release Information"
execute_command "uname -r" "Running Kernel Version"

# Function to check for inxi and display system specs
check_inxi() {
    if command -v inxi &> /dev/null; then
        echo "inxi is installed."
        execute_command "inxi -Fx" "Inxi Detailed System Specs"
    else
        execute_command "echo 'inxi utility is not installed. Install it to get detailed specs about the system.'" "Inxi Detailed System Specs"
    fi
}
check_inxi

# Kernel details command
kernel_details_command=$(cat <<- EOM
echo "Kernel Version: \$(uname -r)"
echo "Kernel Build: \$(uname -v)"
echo "Machine Architecture: \$(uname -m)"
echo "Processor Type: \$(uname -p)"
echo "Operating System: \$(uname -o)"
echo "Kernel Version from /proc: \$(cat /proc/version)"
echo "Kernel Messages: \$(dmesg | grep 'Linux version')"
EOM
)
kernel_latest_html=$(cat <<- EOM
Kernel Version: $(uname -r)<br>
Kernel Build: $(uname -v)<br>
Machine Architecture: $(uname -m)<br>
Processor Type: $(uname -p)<br>
EOM
)

# Main script execution
execute_command "$kernel_details_command" "Kernel Details"

# Function to highlight running kernel in the list of installed images
highlight_running_kernel() {
    local kernel_version=$(uname -r)
    # Determine the distribution
    distro=$(cat /etc/os-release | grep "^ID=" | cut -d'=' -f2 | tr -d '"' | tr '[:upper:]' '[:lower:]')

    # Initialize the variable to store installed images
    installed_images=""

    # Check the distribution and run the appropriate command
    if [[ "$distro" == "ubuntu" || "$distro" == "debian" ]]; then
        local installed_images=$(dpkg --list | grep linux-image)
    elif [[ "$distro" == "centos" || "$distro" == "rhel" ]]; then
        local installed_images=$(rpm -qa | grep kernel)
    else
        echo "Unsupported distribution: $distro"
        exit 1
    fi
    # Output the installed images
    # echo "$installed_images"
    local highlighted_images=$(echo "$installed_images" | sed "s/$kernel_version/<span class='kernel-highlight'>&<\/span>/g")
    echo "$highlighted_images"
}

# Highlighted kernel command
highlighted_kernel_command=$(cat <<- EOM
highlight_running_kernel
EOM
)

# Function to execute commands and log error counts in red
execute_error_count() {
    local command="$1"
    local description="$2"
    local count=$(eval "$command")

    # Log error count description and output to HTML file with red border
    echo "<h3 class='error-section'>$description</h3>" >> "$html_file"
    echo "<p class='error-count'>$count</p>" >> "$html_file"

    # Log error count description and output to log file with separators
    echo "--------------------------------------------------------------------------------------------------------" >> "$log_file"
    echo "$current_date - ERROR COUNT: $description" >> "$log_file"
    echo "$count" >> "$log_file"
    echo "--------------------------------------------------------------------------------------------------------" >> "$log_file"
}

# Execute the command with kernel highlight
execute_command "$highlighted_kernel_command" "Installed Linux Images with Highlighted Running Kernel"

# Amount of installed kernels
# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for dpkg and rpm commands
if command_exists dpkg; then
    echo "dpkg is installed."
    execute_command "dpkg --list | grep linux-image | wc -l" "Amount of APT Installed Kernels"
elif command_exists rpm; then
    execute_command "rpm -qa | grep kernel | wc -l" "Amount of RPM Installed Kernels"
elif command_exists yum; then
    execute_command "yum list installed kernel | wc -l" "Amount of YUM Installed kernels"
elif command_exists dnf; then
    execute_command "dnf list installed kernel | wc -l" "Amount of DNF Installed Kernels"
else
    execute_error_command "Error: Neither dpkg, rpm, yum nor dnf package managers were found installed" "Amount of Installed Kernels"
fi

# Amount of kernel modules
execute_command "find /lib/modules/$(uname -r)/kernel/ -name '*.ko*' | wc -l" "Amount of Kernel Modules"

# List of kernel modules
execute_command "find /lib/modules/$(uname -r)/kernel/ -name '*.ko*'" "Running Kernel Modules List"

# Ip address info
execute_command "ip a" "Ip address information"

execute_command "df -h" "Disk Usage Information"
execute_command "free -h" "Memory Usage Information"
execute_command "top -b -n 1" "Top Command Output (One Snapshot)"
execute_command "last" "Last Logins"

# Check for errors in system logs
execute_error_command "journalctl -b --grep 'error'" "Journalctl: Errors in System Logs"
execute_error_command "dmesg | grep -i 'error\|fail\|warn'" "Dmesg Kernel Errors"

# Check for /var/log/auth.log and look for errors or authentication failures
if [ -f /var/log/auth.log ]; then
  execute_error_command "cat /var/log/auth.log | grep -E 'error|authentication failure'" "Errors in /var/log/auth.log"
  execute_error_count "cat /var/log/auth.log | grep -E 'error|authentication failure' | wc -l" "Amount of Errors in /var/log/auth.log"

fi

# Check for /var/log/secure and look for errors or authentication failures
if [ -f /var/log/secure ]; then
  execute_error_command "cat /var/log/secure | grep -E 'error|authentication failure'" "Errors in /var/log/secure"
  execute_error_count "grep -E 'error|authentication failure' /var/log/secure | wc -l" "Amount of Errors in /var/log/secure"
fi

execute_error_count "journalctl -b --grep 'error' | wc -l" "Amount of errors in Journalctl"
execute_error_count "dmesg | grep -i 'error\|fail\|warn' | wc -l" "Amount of errors in Dmesg"


# Function to check for Debian-based distribution
check_debian() {
    if command -v apt &> /dev/null; then
        echo "APT is installed."
        execute_command "apt list --installed" "APT Installed Packages"

        # Amount of APT packages
        execute_command "apt list --installed | wc -l" "Amount of Installed APT Packages"
    elif command -v dnf &> /dev/null; then
        echo "DNF is installed but the system is Debian-based."
        execute_command "dnf list installed" "DNF Installed Packages"
    elif command -v yum &> /dev/null; then
        echo "YUM is installed but the system is Debian-based."
        execute_command "yum list installed" "YUM Installed Packages"
    else
        echo "No known package manager found (APT, DNF, or YUM)."
    fi
}

# Function to check for RPM command
check_rpm() {
    if command -v rpm &> /dev/null; then
        echo "RPM is installed."
        execute_command "rpm -qa" "RPM Installed Packages"

        # Amount of RPM packages
        execute_command "rpm -qa | wc -l" "Amount of Installed RPM Packages"
    else
        echo "RPM is not installed."
    fi
}

check_yum() {
    if command -v yum &> /dev/null; then
        echo "YUM is installed."
        execute_command "yum list installed" "YUM Installed Packages"

        # Amount of RPM packages
        execute_command "yum list installed | wc -l" "Amount of Installed YUM Packages"
    else
        echo "YUM is not installed."
    fi
}

# Function to check for RHEL-based distribution
check_rhel() {
    if command -v dnf &> /dev/null; then
        echo "DNF is installed."
        execute_command "dnf list installed" "DNF Installed Packages"

        # Amount of DNF packages
        execute_command "dnf list installed | wc -l" "Amount of Installed DNF Packages"
    else
        echo "No known package manager found DNF."
    fi
}

# Identify the Linux distribution and execute relevant commands
distro=$(grep "^ID=" /etc/os-release | cut -d= -f2 | tr -d '"')
distro=$(echo "$distro" | tr '[:upper:]' '[:lower:]')  # Convert to lowercase

case "$distro" in
    "debian"|"ubuntu")
        check_debian
        ;;
    "rhel"|"centos"|"fedora"|"alma"|"rocky")
        check_rhel
        check_yum
        check_rpm
        ;;
    *)
        echo "Unsupported distribution: $distro"
        ;;
esac


# Check for apt history log
if [ -f /var/log/apt/history.log ]; then
    execute_command "cat /var/log/apt/history.log" "Last APT History Logfile Output"
    execute_command "zcat /var/log/apt/history.log.1.gz" "Second archived APT History Logfile Output"
    execute_command "zcat /var/log/apt/history.log.1.gz" "Third archived APT History Logfile Output"
fi

# Check for yum history log
if [ -f /var/log/yum.log ]; then
    execute_command "cat /var/log/yum.log" "YUM History Logfile Output"
fi

# If neither log file is found
if [ ! -f /var/log/apt/history.log ] && [ ! -f /var/log/yum.log ]; then
    echo "No package manager history file found."
fi

# Close the HTML file
cat <<EOF >> "$html_file"
    <div class="footer">
        <p class="footer-highlight">Report End timestamp: $(date +"%Y-%m-%d %H:%M:%S")</p>
        <p class="footer-highlight">Generated by System Info Script</p>
    </div>
</body>
</html>
EOF

# Define previous report paths
prev_report_log=$(ls -t ${report_dir}/system_info_*.log | sed -n '2p')
prev_report_html=$(ls -t ${report_dir}/system_info_report_*.html | sed -n '2p')

echo "System information has been collected and saved to $log_file and $html_file."

#---------------------------------------------END OF HTML AND LOG REPORT---------------------------------------------#

#---------------------------------------------BEGINNING OF DIFFS REPORT---------------------------------------------#

#!/bin/bash

# Define the directory where reports are saved
report_dir="system_info_reports"

# Define the file patterns for report logs
log_pattern="system_info_*.log"

# Get the two most recent log files
log_files=($(ls -1t "$report_dir"/$log_pattern | head -n 2))

# Check if we have at least two log files
if [ ${#log_files[@]} -lt 2 ]; then
    echo "Not enough log files found. Ensure there are at least two log files."
    exit 1
fi

# Assign the latest and second latest files
latest_file="${log_files[0]}"
second_latest_file="${log_files[1]}"

# Extract the datestamp from each file
latest_timestamp=$(basename "$latest_file" | sed 's/system_info_\(.*\)\.log/\1/')
second_latest_timestamp=$(basename "$second_latest_file" | sed 's/system_info_\(.*\)\.log/\1/')

# Determine the system type
if grep -qi "debian" /etc/os-release || grep -qi "ubuntu" /etc/os-release; then
    system_type="debian"
elif grep -qi "centos" /etc/os-release || grep -qi "rhel" /etc/os-release || grep -qi "rocky" /etc/os-release || grep -qi "alma" /etc/os-release; then
    system_type="rhel"
else
    system_type="unknown"
fi

# Extract Hostname Information section from "Static hostname" to "Operating System"
latest_hostname_info=$(awk '/Static hostname/{flag=1} /Operating System/{flag=0} flag' "$latest_file")
second_latest_hostname_info=$(awk '/Static hostname/{flag=1} /Operating System/{flag=0} flag' "$second_latest_file")

# Compare the hostname information between the two log files
if [ "$latest_hostname_info" != "$second_latest_hostname_info" ]; then
    echo "The systems in the log files are different. Aborting the report generation."
    echo "Latest System Info ($latest_timestamp):"
    echo "$latest_hostname_info"
    echo "Second Latest System Info ($second_latest_timestamp):"
    echo "$second_latest_hostname_info"
    exit 1
else
    echo "The systems in the two previous reports are the same. Proceeding with the report..."
fi

# Initialize variables for package counts
latest_installed_kernel=""
latest_kernels=""
latest_modules=""
latest_packages=""
latest_journalctl_errors=""
latest_dmesg_errors=""
latest_authlog_errors=""
latest_installed_APT_packages=""
latest_yum_packages=""
latest_rpm_packages=""
latest_dnf_packages=""

second_latest_installed_kernel=""
second_latest_kernels=""
second_latest_modules=""
second_latest_packages=""
second_latest_journalctl_errors=""
second_latest_dmesg_errors=""
second_latest_authlog_errors=""
second_latest_installed_APT_packages=""
second_latest_yum_packages=""
second_latest_rpm_packages=""
second_latest_dnf_packages=""

# Extract values from the latest log file based on the system type
if [ "$system_type" = "debian" ]; then
    latest_installed_kernel=$(grep -A 1 "Running Kernel Version" "$latest_file" | tail -n 1)
    latest_kernels=$(grep -A 1 "Amount of APT Installed Kernels" "$latest_file" | tail -n 1)
    latest_modules=$(grep -A 1 "Amount of Kernel Modules" "$latest_file" | tail -n 1)
    latest_packages=$(grep -A 1 "Amount of Installed APT Packages" "$latest_file" | tail -n 1)
    latest_journalctl_errors=$(grep -A 1 "Amount of errors in Journalctl" "$latest_file" | tail -n 1)
    latest_dmesg_errors=$(grep -A 1 "Amount of errors in Dmesg" "$latest_file" | tail -n 1)
    latest_authlog_errors=$(grep -A 1 "Amount of Errors in /var/log/auth.log" "$latest_file" | tail -n 1)
else
    latest_installed_kernel=$(grep -A 1 "Running Kernel Version" "$latest_file" | tail -n 1)
    latest_yum_packages=$(grep -A 1 "Amount of Installed YUM Packages" "$latest_file" | tail -n 1)
    latest_rpm_packages=$(grep -A 1 "Amount of Installed RPM Packages" "$latest_file" | tail -n 1)
    latest_dnf_packages=$(grep -A 1 "Amount of Installed DNF Packages" "$latest_file" | tail -n 1)
    latest_journalctl_errors=$(grep -A 1 "Amount of errors in Journalctl" "$latest_file" | tail -n 1)
    latest_dmesg_errors=$(grep -A 1 "Amount of errors in Dmesg" "$latest_file" | tail -n 1)
    latest_authlog_errors=$(grep -A 1 "Amount of Errors in /var/log/auth.log" "$latest_file" | tail -n 1)
    latest_secure_errors=$(grep -A 1 "Amount of Errors in /var/log/secure" "$latest_file" | tail -n 1)
fi

# Extract values from the second latest log file based on the system type
if [ "$system_type" = "debian" ]; then
    second_latest_installed_kernel=$(grep -A 1 "Running Kernel Version" "$second_latest_file" | tail -n 1)
    second_latest_kernels=$(grep -A 1 "Amount of APT Installed Kernels" "$second_latest_file" | tail -n 1)
    second_latest_modules=$(grep -A 1 "Amount of Kernel Modules" "$second_latest_file" | tail -n 1)
    second_latest_packages=$(grep -A 1 "Amount of Installed APT Packages" "$second_latest_file" | tail -n 1)
    second_latest_journalctl_errors=$(grep -A 1 "Amount of errors in Journalctl" "$second_latest_file" | tail -n 1)
    second_latest_dmesg_errors=$(grep -A 1 "Amount of errors in Dmesg" "$second_latest_file" | tail -n 1)
    second_latest_authlog_errors=$(grep -A 1 "Amount of Errors in /var/log/auth.log" "$second_latest_file" | tail -n 1)
else
    second_latest_installed_kernel=$(grep -A 1 "Running Kernel Version" "$second_latest_file" | tail -n 1)
    second_latest_yum_packages=$(grep -A 1 "Amount of Installed YUM Packages" "$second_latest_file" | tail -n 1)
    second_latest_rpm_packages=$(grep -A 1 "Amount of Installed RPM Packages" "$second_latest_file" | tail -n 1)
    second_latest_dnf_packages=$(grep -A 1 "Amount of Installed DNF Packages" "$second_latest_file" | tail -n 1)
    second_latest_journalctl_errors=$(grep -A 1 "Amount of errors in Journalctl" "$second_latest_file" | tail -n 1)
    second_latest_dmesg_errors=$(grep -A 1 "Amount of errors in Dmesg" "$second_latest_file" | tail -n 1)
    second_latest_authlog_errors=$(grep -A 1 "Amount of Errors in /var/log/auth.log" "$second_latest_file" | tail -n 1)
    second_latest_secure_errors=$(grep -A 1 "Amount of Errors in /var/log/secure" "$second_latest_file" | tail -n 1)
fi

# Calculate deltas, handle empty values
delta_kernels=$((latest_kernels - second_latest_kernels))
delta_modules=$((latest_modules - second_latest_modules))
delta_packages=$((latest_packages - second_latest_packages))
delta_journalctl_errors=$((latest_journalctl_errors - second_latest_journalctl_errors))
delta_dmesg_errors=$((latest_dmesg_errors - second_latest_dmesg_errors))
delta_authlog_errors=$((latest_authlog_errors - second_latest_authlog_errors))
delta_secure_errors=$((latest_secure_errors - second_latest_secure_errors))
delta_apt_installed_packages=$((latest_packages - second_latest_packages))

delta_yum_packages=$((latest_yum_packages - second_latest_yum_packages))
delta_rpm_packages=$((latest_rpm_packages - second_latest_rpm_packages))
delta_dnf_packages=$((latest_dnf_packages - second_latest_dnf_packages))

delta_show_new_installed_apt_packages=$(apt list --installed | tail -n $delta_apt_installed_packages)

# Define the dpkg.log file path
dpkg_log="/var/log/dpkg.log"

# Variables for package statuses
status_ii_list=$(dpkg -l | grep '^ii' | cut -d ' ' -f 3)
status_rc_list=$(dpkg -l | grep '^rc' | cut -d ' ' -f 3)
status_un_list=$(dpkg -l | grep '^un' | cut -d ' ' -f 3)
status_iU_list=$(dpkg -l | grep '^iU' | cut -d ' ' -f 3)
status_rU_list=$(dpkg -l | grep '^rU' | cut -d ' ' -f 3)
status_pn_list=$(dpkg -l | grep '^pn' | cut -d ' ' -f 3)
status_hi_list=$(dpkg -l | grep '^hi' | cut -d ' ' -f 3)
status_ri_list=$(dpkg -l | grep '^ri' | cut -d ' ' -f 3)

# Fetch package statuses and store them in variables
status_ii=$(dpkg -l | grep '^ii' | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $1, $2, $3, $4}')
status_rc=$(dpkg -l | grep '^rc' | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $1, $2, $3, $4}')
status_un=$(dpkg -l | grep '^un' | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $1, $2, $3, $4}')
status_iU=$(dpkg -l | grep '^iU' | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $1, $2, $3, $4}')
status_rU=$(dpkg -l | grep '^rU' | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $1, $2, $3, $4}')
status_pn=$(dpkg -l | grep '^pn' | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $1, $2, $3, $4}')
status_hi=$(dpkg -l | grep '^hi' | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $1, $2, $3, $4}')
status_ri=$(dpkg -l | grep '^ri' | awk '{printf "<tr><td>%s</td><td>%s</td><td>%s</td><td>%s</td></tr>\n", $1, $2, $3, $4}')


status_ii_count_list=$(dpkg -l | grep '^ii' | wc -l)
status_rc_count_list=$(dpkg -l | grep '^rc' | wc -l)
status_un_count_list=$(dpkg -l | grep '^un' | wc -l)
status_iU_count_list=$(dpkg -l | grep '^iU' | wc -l)
status_rU_count_list=$(dpkg -l | grep '^rU' | wc -l)
status_pn_count_list=$(dpkg -l | grep '^pn' | wc -l)
status_hi_count_list=$(dpkg -l | grep '^hi' | wc -l)
status_ri_count_list=$(dpkg -l | grep '^ri' | wc -l)

# Variables to capture installation, upgrade, and removal entries, excluding 'startup packages'
install_list_count=$(grep 'install' "$dpkg_log" | grep -v 'startup packages' | wc -l)
upgrade_list_count=$(grep 'upgrade' "$dpkg_log" | grep -v 'startup packages' | wc -l)
remove_list_count=$(grep 'remove' "$dpkg_log" | grep -v 'startup packages' | wc -l)

rm -rf install_list.log
rm -rf upgrade_list.log
rm -rf remove_list.log

# Variables to capture installation, upgrade, and removal entries, excluding 'startup packages'
install_list=$(grep 'install' "$dpkg_log" | grep -v 'startup packages')
upgrade_list=$(grep 'upgrade' "$dpkg_log" | grep -v 'startup packages')
remove_list=$(grep 'remove' "$dpkg_log" | grep -v 'startup packages')

# Convert lists to readable format and remove leading whitespace from each line
installed_packages=$(echo "$install_list" | sed 's/$/<br>/')
upgraded_packages=$(echo "$upgrade_list" | sed 's/$/<br>/')
removed_packages=$(echo "$remove_list" | sed 's/$/<br>/')

# Load previous status counts from the second latest report
prev_status_ii=$(grep '^ii: ' "$second_latest_file" | awk '{print $2}')
prev_status_rc=$(grep '^rc: ' "$second_latest_file" | awk '{print $2}')
prev_status_un=$(grep '^un: ' "$second_latest_file" | awk '{print $2}')
prev_status_iU=$(grep '^iU: ' "$second_latest_file" | awk '{print $2}')
prev_status_rU=$(grep '^rU: ' "$second_latest_file" | awk '{print $2}')
prev_status_pn=$(grep '^pn: ' "$second_latest_file" | awk '{print $2}')
prev_status_hi=$(grep '^hi: ' "$second_latest_file" | awk '{print $2}')
prev_status_ri=$(grep '^ri: ' "$second_latest_file" | awk '{print $2}')

# Load previous APT operations counts from the second latest report
prev_install_ops=$(grep '^installed: ' "$second_latest_file" | awk '{print $2}')
prev_upgrade_ops=$(grep '^upgrade: ' "$second_latest_file" | awk '{print $2}')
prev_remove_ops=$(grep '^remove: ' "$second_latest_file" | awk '{print $2}')

# Calculate deltas
delta_ii=$(( $status_ii_count_list - prev_status_ii ))
delta_rc=$(( $status_rc_count_list - prev_status_rc ))
delta_un=$(( $status_un_count_list - prev_status_un ))
delta_iU=$(( $status_iU_count_list - prev_status_iU ))
delta_rU=$(( $status_rU_count_list - prev_status_rU ))
delta_pn=$(( $status_pn_count_list - prev_status_pn ))
delta_hi=$(( $status_hi_count_list - prev_status_hi ))
delta_ri=$(( $status_ri_count_list - prev_status_ri ))

delta_install_ops=$(( $install_list_count - prev_install_ops ))
delta_upgrade_ops=$(( $upgrade_list_count - prev_upgrade_ops ))
delta_remove_ops=$(( $remove_list_count - prev_remove_ops ))

# Save the current report for future delta calculations
echo "----------------------------------------------------------------------------------------------------------"
echo "DPKG STATUSES: " >> "$latest_file"
echo >> "$latest_file"
echo "ii: ${status_ii}" >> "$latest_file"
echo "rc: ${status_rc}" >> "$latest_file"
echo "un: ${status_un}" >> "$latest_file"
echo "iU: ${status_iU}" >> "$latest_file"
echo "rU: ${status_rU}" >> "$latest_file"
echo "pn: ${status_pn}" >> "$latest_file"
echo "hi: ${status_hi}" >> "$latest_file"
echo "ri: ${status_ri}" >> "$latest_file"

echo "install: ${install_ops}" >> "$latest_file"
echo "upgrade: ${upgrade_ops}" >> "$latest_file"
echo "remove: ${remove_ops}" >> "$latest_file"

previous_kernel_version="Previous kernel from earlier report: $second_latest_installed_kernel"
# Define the class to use for kernel highlighting
if [[ "$latest_installed_kernel" != "$second_latest_installed_kernel" ]]; then
    new_kernel_check="KERNEL UPDATE DETECTED: You are using a new kernel version: $latest_installed_kernel"
    kernel_highlight_class="kernel-highlight-red"  # Fluorescent cyan for new kernel
else
    new_kernel_check="Current running kernel: $latest_installed_kernel<br><br>You are using the same kernel version detected in the previous report."
    kernel_highlight_class="kernel-highlight"  # Green highlight for same kernel
fi

# Generate the diff report based on the detected system type
diff_file="system_info_reports/diff_report_$(date +'%Y_%m_%d_%H_%M_%S').html"

# Extract Name and Version from /etc/os-release
os_name=$(grep '^NAME=' /etc/os-release | cut -d= -f2 | tr -d '"')
os_version=$(grep '^VERSION=' /etc/os-release | cut -d= -f2 | tr -d '"')
os_title="${os_name} - ${os_version}"

cat <<EOF > "$diff_file"
<html>
<head>
    <title>$os_title - System Info Diff Report</title>
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; line-height: 1.4; margin: 0; padding: 0; background-color: #1e1e1e; color: #e0e0e0; }
        h1 { color: #00ffff; text-align: center; font-size: 2em; margin: 15px; }
        h3 { color: #ffffff; background-color: #333333; padding: 5px; margin: 10px 0; border-left: 10px solid #00ffff; border-right: 10px solid #00ffff; border-radius: 5px; font-size: 1.2em; }
        .code-block { background-color: #000000; color: #ffffff; border: 3px solid #ffffff; padding: 5px; border-radius: 10px; max-width: 100%; font-family: 'Courier New', Courier, monospace; width: auto; height: auto; margin-bottom: 10px; }
        .kernel-highlight { background-color: #000000; color: #00ff00; border: 2px solid #00ff00; padding: 10px; border-radius: 5px; box-shadow: 0 0 10px 5px rgba(0, 255, 0, 0.75); display: inline-block; }
        .kernel-highlight span.variable {color: #39FF14; font-weight: bold;}
         @keyframes blink { 0% { opacity: 1; } 50% { opacity: 0; } 100% { opacity: 1; } }
        .kernel-highlight-red { background-color: #000000; color: #ffffff; border: 2px solid #ff073a; padding: 10px; border-radius: 5px; box-shadow: 0 0 10px 5px rgba(255, 7, 58, 0.75); display: inline-block; font-weight: bold; animation: blink 1s infinite; }
        .kernel-highlight-red span.variable { color: #ffffff; font-weight: bold; animation: blink 1s infinite; }
        .kernel-highlight2 { background-color: #000000; color: #ffff00; border: 2px solid #ffff00; padding: 10px; border-radius: 5px; box-shadow: 0 0 10px 5px rgba(255, 255, 0, 0.75); display: inline-block; }
        .kernel-highlight2 span.variable {color: #39FF14; font-weight: bold;}
        .error-section {color: #ffffff; background-color: #333; padding: 15px; margin: 10px 0; border-left: 15px solid red; border-right: 15px solid red; border-radius: 5px;}
        .value-box { background-color: #39ff14; color: #000000; border: 1px solid #00ff00; padding: 8px; border-radius: 5px; display: inline-block; margin: 0 5px; font-size: 1em; font-weight: bold; }
        .value-box2 { background-color: #ff0000; color: #000000; border: 1px solid #00ff00; padding: 8px; border-radius: 5px; display: inline-block; margin: 0 5px; font-size: 1em; font-weight: bold; }
        .delta { color: #ff6347; font-weight: bold; }
        .h3 { color: #555; }
        .table { width: 100%; border-collapse: collapse; margin-top: 10px; }
        .th, td { padding: 8px; text-align: left; border-bottom: 1px solid #ddd; }
        .th { background-color: #f4f4f4; }
        .status { font-weight: bold; }
        .delta { color: red; }
        .footer { text-align: center; margin-top: 15px; font-size: 0.8em; color: #888888; }
        .footer-highlight { background-color: #00ffff; color: #000000; padding: 8px; border-radius: 5px; font-size: 0.9em; text-align: center; }
        .container { width: 95%; margin: 20px auto; background: #2a2a2a; padding: 15px; border-radius: 8px; box-shadow: 0 0 15px rgba(0, 255, 255, 2); }
        .report-section { margin: 5px 0; }
    </style>
</head>
<body>
    <div class="container">
        <h1>$os_title - System Information Diff Report</h1>
        <div class="code-block">
            Latest Report ($latest_timestamp):
<pre>$latest_hostname_info
        </div>
        <div class="code-block">
            Second Latest Report ($second_latest_timestamp):
<pre>$second_latest_hostname_info
        </div>
        <div class="code-block">
              Running kernel Version:<br>
              $kernel_latest_html<br>
              <div class="kernel-highlight2">
                  <span class="variable">$previous_kernel_version<br></span>
              </div>
              <br>
              <br>
              <div class="$kernel_highlight_class">
                  <span class="variable">$new_kernel_check</span>
              </div>
        </div>

EOF

# Append Debian-specific sections
if [ "$system_type" = "debian" ]; then
    cat <<EOF >> "$diff_file"
        <div class="code-block">
            <h3>Amount of APT Installed Kernels</h3>
            <p class="report-section">Latest Report Count: <span class="value-box">$latest_kernels</span></p>
            <p class="report-section">Second Latest Report Count: <span class="value-box">$second_latest_kernels</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box">$delta_kernels</span></p>
        </div>
        <div class="code-block">
            <h3>Amount of Kernel Modules</h3>
            <p class="report-section">Latest Report Count: <span class="value-box">$latest_modules</span></p>
            <p class="report-section">Second Latest Report Count: <span class="value-box">$second_latest_modules</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box">$delta_modules</span></p>
        </div>
        <div class="code-block">
            <h3>Amount of Installed APT Packages</h3>
            <p class="report-section">Latest Report Count: <span class="value-box">$latest_packages</span></p>
            <p class="report-section">Second Latest Report Count: <span class="value-box">$second_latest_packages</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box">$delta_packages</span></p>
        </div>
        <div class="code-block">
          <h3>APT STATUSES amounts</h3>
          <table>
              <tr><th>Status</th><th>Packages status code flag description</th><th>Amount</th><th>Deltas</th></tr>
              <tr><td class="status">ii</td><td>Installed</td><td>${status_ii_count_list}</td><td class="delta">${delta_ii}</td></tr>
              <tr><td class="status">rc</td><td>Removed but configuration files remain</td><td>${status_rc_count_list}</td><td class="delta">${delta_rc}</td></tr>
              <tr><td class="status">un</td><td>Not Installed - Unknown</td><td>${status_un_count_list}</td><td class="delta">${delta_un}</td></tr>
              <tr><td class="status">iU</td><td>Unpacked - Pending Configuration</td><td>${status_iU_count_list}</td><td class="delta">${delta_iU}</td></tr>
              <tr><td class="status">rU</td><td>Removed, but Unpacked - Pending Configuration</td><td>${status_rU_count_list}</td><td class="delta">${delta_rU}</td></tr>
              <tr><td class="status">pn</td><td>Purged</td><td>${status_pn_count_list}</td><td class="delta">${delta_pn}</td></tr>
              <tr><td class="status">hi</td><td>On hold and installed</td><td>${status_hi_count_list}</td><td class="delta">${delta_hi}</td></tr>
              <tr><td class="status">ri</td><td>Reinstalled</td><td>${status_ri_count_list}</td><td class="delta">${delta_ri}</td></tr>
          </table>
        </div>
        <div class="code-block">
			<h3>Installed Packages (ii)</h3>
			<table>
				<tr><th>Status</th><th>Package</th><th>Version</th><th>Architecture</th></tr>
				${status_ii}
			</table>

			<h3>Removed Config Packages (rc)</h3>
			<table>
				<tr><th>Status</th><th>Package</th><th>Version</th><th>Architecture</th></tr>
				${status_rc}
			</table>

			<h3>Uninstalled Packages (un)</h3>
			<table>
				<tr><th>Status</th><th>Package</th><th>Version</th><th>Architecture</th></tr>
				${status_un}
			</table>

			<h3>Partially Installed Packages (iU)</h3>
			<table>
				<tr><th>Status</th><th>Package</th><th>Version</th><th>Architecture</th></tr>
				${status_iU}
			</table>

			<h3>Partially Removed Packages (rU)</h3>
			<table>
				<tr><th>Status</th><th>Package</th><th>Version</th><th>Architecture</th></tr>
				${status_rU}
			</table>

			<h3>Pending Packages (pn)</h3>
			<table>
				<tr><th>Status</th><th>Package</th><th>Version</th><th>Architecture</th></tr>
				${status_pn}
			</table>

			<h3>Half Installed Packages (hi)</h3>
			<table>
				<tr><th>Status</th><th>Package</th><th>Version</th><th>Architecture</th></tr>
				${status_hi}
			</table>

			<h3>Reinstallation Required (ri)</h3>
			<table>
				<tr><th>Status</th><th>Package</th><th>Version</th><th>Architecture</th></tr>
				${status_ri}
			</table>
		</div>
        <div class="code-block">
          <h3>APT Packages ran Operations amounts</h3>
          <table>
              <tr><th>Operation</th><th>Amount of operations</th><th>Deltas</th></tr>
              <tr><td class="status">Installed</td><td>${install_list_count}</td><td class="delta">${delta_install_ops}</td></tr>
              <tr><td class="status">Upgraded</td><td>${upgrade_list_count}</td><td class="delta">${delta_upgrade_ops}</td></tr>
              <tr><td class="status">Removed</td><td>${remove_list_count}</td><td class="delta">${delta_remove_ops}</td></tr>
          </table>
        </div>
		<div class="code-block">
			<h3>/var/log/dpkg.log installed packages</h3>
				$installed_packages
        </div>
        <div class="code-block">
			<h3>/var/log/dpkg.log upgraded packages</h3>
				$upgraded_packages
        </div>
        <div class="code-block">
			<h3>/var/log/dpkg.log removed packages</h3>
				$removed_packages
        </div>
        <div class="code-block">		
            <h3 class="error-section"> Amount of Errors in Journalctl</h3>
            <p class="error-section">Latest Report Count: <span class="value-box2">$latest_journalctl_errors</span></p>
            <p class="error-section">Second Latest Report Count: <span class="value-box2">$second_latest_journalctl_errors</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box2">$delta_journalctl_errors</span></p>
        </div>
        <div class="code-block">
            <h3 class="error-section">Amount of Errors in Dmesg</h3>
            <p class="error-section">Latest Report Count: <span class="value-box2">$latest_dmesg_errors</span></p>
            <p class="error-section">Second Latest Report Count: <span class="value-box2">$second_latest_dmesg_errors</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box2">$delta_dmesg_errors</span></p>
        </div>
        <div class="code-block">
            <h3 class="error-section">Amount of Errors in /var/log/auth.log</h3>
            <p class="error-section">Latest Report Count: <span class="value-box2">$latest_authlog_errors</span></p>
            <p class="error-section">Second Latest Report Count: <span class="value-box2">$second_latest_authlog_errors</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box2">$delta_authlog_errors</span></p>
        </div>
EOF
elif [ "$system_type" = "rhel" ]; then
    cat <<EOF >> "$diff_file"
        <div class="code-block">
            <h3>Amount of Installed YUM Packages</h3>
            <p class="report-section">Latest Report Count: <span class="value-box">$latest_yum_packages</span></p>
            <p class="report-section">Second Latest Report Count: <span class="value-box">$second_latest_yum_packages</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box">$delta_yum_packages</span></p>
        </div>
        <div class="code-block">
            <h3>Amount of Installed RPM Packages</h3>
            <p class="report-section">Latest Report Count: <span class="value-box">$latest_rpm_packages</span></p>
            <p class="report-section">Second Latest Report Count: <span class="value-box">$second_latest_rpm_packages</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box">$delta_rpm_packages</span></p>
        </div>
        <div class="code-block">
            <h3>Amount of Installed DNF Packages</h3>
            <p class="report-section">Latest Report Count: <span class="value-box">$latest_dnf_packages</span></p>
            <p class="report-section">Second Latest Report Count: <span class="value-box">$second_latest_dnf_packages</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box">$delta_dnf_packages</span></p>
        </div>
        <div class="code-block">
            <h3 class="error-section"> Amount of Errors in Journalctl</h3>
            <p class="error-section">Latest Report Count: <span class="value-box2">$latest_journalctl_errors</span></p>
            <p class="error-section">Second Latest Report Count: <span class="value-box2">$second_latest_journalctl_errors</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box2">$delta_journalctl_errors</span></p>
        </div>
        <div class="code-block">
            <h3 class="error-section">Amount of Errors in Dmesg</h3>
            <p class="error-section">Latest Report Count: <span class="value-box2">$latest_dmesg_errors</span></p>
            <p class="error-section">Second Latest Report Count: <span class="value-box2">$second_latest_dmesg_errors</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box2">$delta_dmesg_errors</span></p>
        </div>
        <div class="code-block">
            <h3 class="error-section">Amount of Errors in /var/log/auth.log</h3>
            <p class="error-section">Latest Report Count: <span class="value-box2">$latest_authlog_errors</span></p>
            <p class="error-section">Second Latest Report Count: <span class="value-box2">$second_latest_authlog_errors</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box2">$delta_authlog_errors</span></p>
        </div>
        <div class="code-block">
            <h3 class="error-section">Amount of Errors in /var/log/secure</h3>
            <p class="error-section">Latest Report Count: <span class="value-box2">$latest_secure_errors</span></p>
            <p class="error-section">Second Latest Report Count: <span class="value-box2">$second_latest_secure_errors</span></p>
            <p class="delta">Delta (Latest vs Second Latest): <span class="value-box2">$delta_secure_errors</span></p>
        </div>
EOF
fi

cat <<EOF >> "$diff_file"
        <div class="footer">
            <p class="footer-highlight">End of Report</p>
        </div>
    </div>
</body>
</html>
EOF

echo "Diff report generated: $diff_file"
