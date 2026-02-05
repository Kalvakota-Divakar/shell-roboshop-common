#!/bin/bash
# common.sh file is sourced to use the common functions and variables defined in it.
source ./common.sh
app_name=user
# checking for root user access.
check_root
app_setup
nodejs_setup
systemd_setup
print_total_time