#! /bin/bash

export PATH=/usr/local/rvm/gems/ruby-2.1.2/bin:/usr/local/rvm/gems/ruby-2.1.2@global/bin:/usr/local/rvm/rubies/ruby-2.1.2/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/rvm/bin
export rvm_bin_path=/usr/local/rvm/bin
export GEM_HOME=/usr/local/rvm/gems/ruby-2.1.2
export IRBRC=/usr/local/rvm/rubies/ruby-2.1.2/.irbrc
export OLDPWD=/usr/local/rvm/gems/ruby-2.1.2
export MY_RUBY_HOME=/usr/local/rvm/rubies/ruby-2.1.2
export rvm_path=/usr/local/rvm
export rvm_prefix=/usr/local
export PWD=/usr/local/rvm/gems/ruby-2.1.2/gems
export rvm_version="1.25.33 (stable)"
export GEM_PATH=/usr/local/rvm/gems/ruby-2.1.2:/usr/local/rvm/gems/ruby-2.1.2@global
export RUBY_VERSION=ruby-2.1.2
#/usr/local/rvm/rubies/ruby-2.1.2/bin/ruby /var/work/kaoru_home/crawler/download_weather.rb &> /var/work/kaoru_home/crawler/log/`date +weather_%Y%m%d_%H%M%S.log`

logfile=`date +movie_download_%Y%m%d_%H%M%S.log`
cd /var/work/kaoru_home
RAILS_ENV=production /usr/local/rvm/gems/ruby-2.1.2/bin/rake movie:download &>> /var/work/kaoru_home/crawler/log/$logfile
echo "\n\n" &>> /var/work/kaoru_home/crawler/log/$logfile
RAILS_ENV=production /usr/local/rvm/gems/ruby-2.1.2/bin/rake movie:solr_clear &>> /var/work/kaoru_home/crawler/log/$logfile
echo "\n\n" &>> /var/work/kaoru_home/crawler/log/$logfile
RAILS_ENV=production /usr/local/rvm/gems/ruby-2.1.2/bin/rake movie:solr_import &>> /var/work/kaoru_home/crawler/log/$logfile

