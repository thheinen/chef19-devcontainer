(hiddden issue: location of tempfiles on executing node)

[2025-05-11T15:42:24+00:00] DEBUG: Chef::Exceptions::Cron: cron[daily_script] (test::debug line 62) had an error: Chef::Exceptions::Cron: Error updating state of daily_script, error: closed stream
/hab/pkgs/chef/chef-infra-client/19.0.62/20250107162735/vendor/gems/chef-19.0.62/lib/chef/provider/cron.rb:217:in `rescue in write_crontab'
/hab/pkgs/chef/chef-infra-client/19.0.62/20250107162735/vendor/gems/chef-19.0.62/lib/chef/provider/cron.rb:205:in `write_crontab'
