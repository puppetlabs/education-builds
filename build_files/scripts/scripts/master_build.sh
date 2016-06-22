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
cd /usr/src/
git clone https://github.com/puppetlabs/education-builds
cd /usr/src/education-builds/scripts

rake master_build
