#! /bin/sh

## This is a particularly icky script that just caches the root
#  password so we can use the mysql resource types to manage the
#  Drupal database creation.
# 

source /root/puppet-enterprise/answers.lastrun.`hostname`

echo -n "[client]
user=root
host=localhost
password=${q_puppet_enterpriseconsole_database_root_password}
" > /root/.my.cnf
