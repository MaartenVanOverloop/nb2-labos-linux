#! /usr/bin/bash
#
# Acceptance test script for srv010
admin_user=bert

@test "Bash-completion should have been installed" {
  # This file should exist if bash-completion was installed
  [ -f /etc/profile.d/bash_completion.sh ]
}

@test "bind-utils should have been installed" {
  # Ask version of dig, this should execute with exit status 0
  dig -v
}

@test "Git should have been installed" {
  git --version
}

@test "Nano should have been installed" {
  nano --version
}

@test "Tree should have been installed" {
  tree --version
}

@test "Vim-enhanced should have been installed" {
  vim --version
}

@test "Wget should have been installed" {
  wget --version
}

@test "SELinux status should be Enforcing" {
  run getenforce
  [ "${status}" -eq 0 ]
  [ "${output}" = 'Enforcing' ]
}

@test "The firewall should be running and loaded at boot time" {
  systemctl is-active firewalld.service
  systemctl is-enabled firewalld.service
}

@test "Admin user ${admin_user} should exist" {
  # The user should exist
  getent passwd ${admin_user}
  # and should be member of the `wheel` group
  [ -n "$(groups ${admin_user} | grep wheel)" ]
}


