cd /var/work/kaoru_home
RAILS_ENV=production /usr/local/rvm/gems/ruby-2.1.2/bin/rake lottery_statistic:lottery649s_rank &> /var/work/kaoru_home/crawler/log/`date +lottery649s_rank_%Y%m%d_%H%M%S.log`
