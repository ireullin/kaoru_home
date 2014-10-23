#! /bin/bash

/usr/local/rvm/rubies/ruby-2.1.2/bin/ruby /var/work/kaoru_home/crawler/download_weather.rb &> /var/work/kaoru_home/crawler/log/`date +weather_%Y%m%d_%H%M%S.log`




