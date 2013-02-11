#! /bin/sh

## This is a particularly icky script that just caches the root
#  password so we can use the mysql resource types to manage the
#  Drupal database creation.
# 

source /root/puppet-enterprise/answers.lastrun.`hostname`

if [ "${q_puppet_enterpriseconsole_database_root_password}" != "" ]
then
  echo -e "[client]\nuser=root\nhost=localhost\npassword=${q_puppet_enterpriseconsole_database_root_password}" > /root/.my.cnf
fi
