#! /bin/bash

bundle install
RAILS_ENV=production rake assets:clean
RAILS_ENV=production rake assets:precompile
RAILS_ENV=production rake db:migrate
/etc/init.d/nginx restart

