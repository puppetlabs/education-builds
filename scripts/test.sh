sleep 300
cd /usr/src/puppet-quest-guide/tests
for q in $(quest list); do
  rspec $q\_spec.rb --tag solution --tag validation
done
