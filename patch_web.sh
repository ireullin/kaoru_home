#! /bin/bash

 RAILS_ENV=production rake assets:precompile
 RAILS_ENV=production rake db:migrate
 /etc/init.d/apache2 restart

