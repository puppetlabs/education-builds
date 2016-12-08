export PATH=/usr/local/bin:/usr/local/sbin:$PATH

# Build and install wkhtmltopdf
# prereqs
yum install -y ruby-devel gcc rpm-build
gem install fpm

# build
curl -O http://download.gna.org/wkhtmltopdf/0.12/0.12.3/wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
tar -xvf wkhtmltox-0.12.3_linux-generic-amd64.tar.xz
fpm -s dir -t rpm -n wkhtmltopdf -v 0.12.3 --prefix /usr -C wkhtmltox .

# install
yum install -y wkhtmltopdf-0.12.3-1.x86_64.rpm
rm -rf wkhtmltopdf-0.12.3-1.x86_64.rpm wkhtmltox wkhtmltox-0.12.3_linux-generic-amd64.tar.xz

# Main build
cd /usr/src/build_files

rake master_build

# Create token for deployer user
echo 'puppetlabs' | HOME=/root /opt/puppetlabs/bin/puppet-access login deployer --lifetime 365d
