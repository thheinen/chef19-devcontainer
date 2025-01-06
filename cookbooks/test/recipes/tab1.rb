### Based on results 20241220 ###

# 02
apt_update do
  action :update
end if debian?

apt_package 'tree' do
  action :install
end if debian?

# 03
apt_preference 'curl' do
  pin 'version 7.68*'
  pin_priority 1001
end if debian?

# 04 - Habitat repository does not work anymore
apt_repository 'corretto' do
  uri          'https://apt.corretto.aws'
  arch         'amd64'
  distribution 'stable'
  components   ['main']
  options      ['target-=Contents-deb']
  key          'https://apt.corretto.aws/corretto.key'
end if debian?

# 05 - see 02

# 06
bash 'Reload daemon' do
  code <<-EOH
    systemctl daemon-reload
  EOH
  action :nothing
end

# 07
breakpoint 'name' do
  action :break
end

# 08
chef_client_config 'default' do
  chef_server_url 'https://your-chef-server/organizations/your-org'
  node_name 'node-name'
  log_location '/var/log/chef-client.log'
  log_level :info
  config_directory '/etc/chef'
  action :nothing
end

# 09
chef_sleep 'pause_for_30_seconds' do
  seconds 30
  action :sleep
end

# 10
cron 'daily_script' do
  minute '0'
  hour '0'
  command '/tmp/local/bin/daily_script.sh'
  user 'root'
  action :create
end

# 11
cron_access 'allow_user' do
  user 'username'
  action :allow
end

# 12
cron_d 'example_job' do
  minute '0'
  hour '2'
  day '*'
  month '*'
  weekday '*'
  command '/usr/bin/example_command'
  user 'root'
  action :create
end

# 13
directory '/tmp/chef-repo' do
  action :create
end

# 14
execute 'test_echo' do
  command 'echo "Target Mode Connected Successfully..!!"'
end

# 15
file '/etc/crontab' do
  mode '0600'
  owner 'root'
  group 'root'
end

# 16
git '/tmp/chef-repo' do
  repository 'https://github.com/chef/chef.git'
  revision 'main'
  action :sync
end

# 17
group 'developers' do
  action :remove
end

# 18
#group 'hab'
#user 'hab' do # does not pass idempotency checks?
#  gid 'hab'
#  not_if 'id hab'
#end
#
# directory '/hab/accepted-licenses' do
#   recursive true
# end
# file '/hab/accepted-licenses/habitat'

habitat_install 'install habitat' do
  hab_version '1.5.50'
end

execute 'hab license accept' # without this, subsequent examples will block on habitat package installation, awaiting license acceptance

# 19 - old example did not match syntax
habitat_sup 'default' do
  listen_ctl '0.0.0.0:9632'
  listen_http '0.0.0.0:9631'
  listen_gossip '0.0.0.0:9938'
end

# 20
hostname 'my-new-hostname' do
  action :set
end

# 21
http_request 'fetch_posts' do
  url 'https://jsonplaceholder.typicode.com/posts'
  action :get
  headers({
    'Accept' => 'application/json'
  })
  not_if { ::File.exist?('/tmp/posts_fetched') }
end

# Execute a command to create a file after fetching posts
execute 'create_post_fetch_file' do
  command 'touch /tmp/posts_fetched'
  action :run
  only_if 'curl -s https://jsonplaceholder.typicode.com/posts | grep ""userId""'
end

# Make a POST request to create a new post
http_request 'create_post' do
  url 'https://jsonplaceholder.typicode.com/posts'
  action :post
  message({
    title: 'foo',
    body: 'bar',
    userId: 1
  }.to_json)
  headers({
    'Content-Type' => 'application/json',
    'Accept' => 'application/json'
  })
end

# 22 - Ubuntu 2204 does not have ifconfig anymore, changed to `ip`
execute 'configure_network_interface' do
  command <<-CMD
    modprobe dummy
    ip link add eth1 type dummy
    ip address add 192.168.1.100/255.255.255.0 dev eth1
  CMD
  action :run
  not_if 'ip address show | grep 192.168.1.100'
end

# 23
kernel_module 'udf' do
  load_dir '/etc/modprobe.d'
  action :disable
end

# 24
s_links = ['/usr/sbin/lsmod', '/usr/sbin/rmmod', '/usr/sbin/insmod', '/usr/sbin/modinfo', '/usr/sbin/modprobe', '/usr/sbin/depmod']
s_links.each do |files|
  link files.to_s do
    to '../bin/kmod'
  end
end

# 25
log "Testing Log Resources....!!!"

# 26
chef_sleep '10' do
  action :sleep
end

notify_group 'crude_stop_and_start' do
  notifies :sleep, 'chef_sleep[10]', :immediately
end

# 27
ohai 'reload' do
  plugin 'etc'
  action :reload
end

# 28
ohai_hint 'ec2' do
 action :create
end

# 29
file '/etc/crontab' do
  mode '0600'
  owner 'root'
  group 'root'
end

# 30
package 'curl' do
  action :install
end

# 31
perl 'hello world' do
  code <<-EOH
    print "Hello world! From Chef and Perl.";
  EOH
end

# 32 - skipped for obvious reasons
# reboot 'now' do
#   action :reboot_now
#   reason 'Cannot continue Chef run without a reboot.'
# end

# 33
remote_file '/etc/index.html' do
  mode '0755'
  action :create
  source 'https://www.google.com/'
end

# 34
ruby_block 'print_message' do
  block do
    puts 'This is a Ruby block in Chef!'
  end
  action :run # Default action
end

# 35
service 'cron' do
  action %i(enable start)
end

# 36
sudo 'webadmin_apache' do
  user 'root'
  commands ['/bin/systemctl restart httpd']
  nopasswd true
  action :create
end

# 37
template '/tmp/ssh_known' do
  source 'default.erb' # 'index.html'
  mode '0644'
  action :create
end

# 38
timezone 'UTC' do
  action :set
end

# 39
user_ulimit 'tomcat' do
  filehandle_limit 8192
  filename 'tomcat_filehandle_limits.conf'
end

# 40
yum_repository 'rhel-repo' do
   reposdir '/tmp/'
   action :create
   make_cache false
end if rhel?
