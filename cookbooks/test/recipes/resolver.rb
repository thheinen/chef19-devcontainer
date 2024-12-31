package 'httpd' # Fails with Yum

yum_package 'httpd' # Succeeds with YumTM

=begin

Generated at 2024-12-31 15:56:35 +0000
NoMethodError: package[httpd] (test::resolver line 1) had an error: NoMethodError: undefined method `flush_cache' for Chef::Resource::Package
/hab/pkgs/chef/chef-infra-client/19.0.59/20241203230658/vendor/gems/chef-19.0.59/lib/chef/resource.rb:1344:in `method_missing'
/hab/pkgs/chef/chef-infra-client/19.0.59/20241203230658/vendor/gems/chef-19.0.59/lib/chef/provider/package/yum.rb:59:in `load_current_resource'
/hab/pkgs/chef/chef-infra-client/19.0.59/20241203230658/vendor/gems/chef-19.0.59/lib/chef/provider.rb:228:in `run_action'
/hab/pkgs/chef/chef-infra-client/19.0.59/20241203230658/vendor/gems/chef-19.0.59/lib/chef/resource.rb:601:in `block in run_action'
/hab/pkgs/chef/chef-infra-client/19.0.59/20241203230658/vendor/gems/chef-19.0.59/lib/chef/resource.rb:628:in `with_umask'
/hab/pkgs/chef/chef-infra-client/19.0.59/20241203230658/vendor/gems/chef-19.0.59/lib/chef/resource.rb:600:in `run_action'

=end
