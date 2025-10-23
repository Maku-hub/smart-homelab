#!/bin/bash

### Log file
LOG_FILE="/root/post_tests.log"

### ANSI color codes
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

### Array of tests
tests=(
    "test_oracle_linux_version"
    "test_required_packages"
    "test_hostname"
    "test_raid1"
    "test_users"
    "test_mikrotik_connection"
    "test_audit_rules"
    "test_ks_post_log"
    "test_var_log"
)

### Function to log information
log_info() {
    local message="[$(date '+%F %T')] ===== $1 ====="
    echo -e "$message" | tee -a "$LOG_FILE"
}

### Function to log command output
log_command_output() {
    local command_output="$1"
    echo -e "$command_output" >> "$LOG_FILE"
}

### Function to perform a test and log the result and command output
perform_test() {
    local test_name="$1"
    local test_function="$2"

    log_info "Running Test ($((++test_count))/$total_tests): $test_name"

    # Capture the command output
    command_output=$($test_function 2>&1)

    if [ $? -eq 0 ]; then
        result="${GREEN}Test Passed${NC}"
    else
        result="${RED}Test Failed${NC}"
    fi

    log_command_output "$command_output"
    log_test_result "$result"
}

### Function to log test results
log_test_result() {
    local result="$1"
    echo -e "$result" >> "$LOG_FILE"
    echo -e "$result"
}

### Test functions

test_oracle_linux_version() {
    grep "Oracle Linux 9" /etc/os-release
}

test_required_packages() {
    required_packages=("dnf-utils" "net-tools" "nano" "vim" "htop" "traceroute" "mc" "openssl" "screen" "tree" "tar" "rsync" "less" "python3" "python3-pip" "mdadm" "tmux" "pykickstart" "fzf" "bat" "inotify-tools" "make" "mtools" "expect" "nmap-ncat" "fail2ban" "logrotate" "libvirt" "docker-ce" "kubelet" "kubeadm" "kubectl" "glow" "nmap" "netcat" "hping3" "tcpdump")
    all_packages_installed=true

    for package in "${required_packages[@]}"; do
        if ! rpm -q "$package" &>/dev/null; then
            all_packages_installed=false
        fi
    done

    if [ "$all_packages_installed" = true ]; then
        return 0
    else
        return 1
    fi
}

test_hostname() {
    [ "$(hostname)" = "srv01.maku.local" ]
}

test_raid1() {
    if [ "$(mdadm --detail /dev/md/root | grep -c 'Active Devices : 2')" -gt 0 ]; then
        if [ "$(mdadm --detail /dev/md/root | grep -c 'Failed Devices : 0')" -gt 0 ]; then
            return 0
        else
            return 1
        fi
    else
        return 1
    fi
}

test_users() {
    required_users=("root" "makusa" "maku")
    all_users_exist=true

    for user in "${required_users[@]}"; do
        if ! id "$user" &>/dev/null; then
            all_users_exist=false
        fi
    done

    if [ "$all_users_exist" = true ]; then
        return 0
    else
        return 1
    fi
}

test_mikrotik_connection() {
    mikrotik_addr="172.25.100.1"
    ping -c 2 $mikrotik_addr &>/dev/null
}

test_audit_rules() {
    auditctl -R /etc/audit/rules.d/audit.rules
}

test_ks_post_log() {
    log_file="/root/ks-post.log"
    keywords=("error" "warn" "fail" "exception" "critical" "fatal" "denied" "unauthorized" "no match" "segfault" "invalid" "unexpected" "misconfiguration" "segmentation" "rejected" "oops" "out of memory" "unreachable")
    #grep -iE 'error|warn|fail|exception|critical|fatal|denied|unauthorized|no match|segfault|invalid|unexpected|misconfiguration|segmentation|rejected|oops|out of memory|unreachable' /root/ks-post.log

    # Check if the log file contains any of the keywords
    if grep -iE "$(IFS=\|; echo "${keywords[*]}")" "$log_file"; then
        return 1
    else
        return 0
    fi
}

test_var_log() {
    log_path="/var/log/"
    keywords=("error" "warn" "fail" "exception" "critical" "fatal" "denied" "unauthorized" "no match" "segfault" "invalid" "unexpected" "misconfiguration" "segmentation" "rejected" "oops" "out of memory" "unreachable")
    #grep -irE 'error|warn|fail|exception|critical|fatal|denied|unauthorized|no match|segfault|invalid|unexpected|misconfiguration|segmentation|rejected|oops|out of memory|unreachable' /var/log/*

    # Check if the log file contains any of the keywords
    if grep -irE "$(IFS=\|; echo "${keywords[*]}")" "$log_path"* | sort | uniq -c | sort -r; then
        return 1
    else
        return 0
    fi
}

### Main script

# Initialize log file
echo -e "Post Tests Log\n" > "$LOG_FILE"

# Count the total number of tests
total_tests=${#tests[@]}
test_count=0

# Run tests
for test_function in "${tests[@]}"; do
    perform_test "${test_function#test_}" "$test_function"
done

# Display overall success or failure message in the log file
if grep -q "Test Failed" "$LOG_FILE"; then
    log_info "${RED}Some tests failed.${NC}"
else
    log_info "${GREEN}All tests passed successfully!${NC}"
fi
