#! /bin/bash
if [ ! -z $FILESHARE_PATH ]
then
  mkdir -p $FILESHARE_PATH/file_cache
  mkdir -p $FILESHARE_PATH/file_cache/gems
  mkdir -p $FILESHARE_PATH/file_cache/installers
  mkdir -p $FILESHARE_PATH/output
  mkdir -p $FILESHARE_PATH/srv/education/packer_cache
  mkdir -p $FILESHARE_PATH/bundle
       
  ln -sTf $FILESHARE_PATH/file_cache file_cache
  ln -sTf $FILESHARE_PATH/output output
  ln -sTf $FILESHARE_PATH/packer_cache packer_cache
  ln -sTf $FILESHARE_PATH/bundle .bundle
  sudo yum install -y ruby-devel gcc-c++ libxml2 libxml2-devel zlib-devel libxslt libxslt-devel
  gem install bundler -f
  bundle config build.nokogiri --use-system-libraries
  bundle install
else
  echo "FILESHARE_PATH is required"
fi
