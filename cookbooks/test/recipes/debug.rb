### Based on results 20241220 ###
=begin
skip_habitat = true

# 02
apt_update do
  action :update
end if debian?

apt_package 'tree' do
  action :install
end if debian?
=end
# 03
apt_preference 'curl' do
  pin 'version 7.68*'
  pin_priority 1001
end if debian?
=begin
# 04 - Habitat repository does not work anymore
apt_repository 'corretto' do
  uri          'https://apt.corretto.aws'
  arch         'amd64'
  distribution 'stable'
  components   ['main']
  options      ['target-=Contents-deb']
  key          'https://apt.corretto.aws/corretto.key'
end if debian? && false

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
end if false

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
end if false

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
package 'git' # missing on RHEL8

git '/tmp/chef-repo' do
  repository 'https://github.com/chef/chef.git'
  revision 'main'
  action :sync
end

# 17
group 'developers' do
  action :remove
end

# 18 - wonky (TODO)
#user 'hab' do # does not pass idempotency checks?
#  not_if 'id hab'
#end
#group 'hab'

habitat_install 'install habitat' do
  hab_version '1.5.50'
end unless skip_habitat

# without this, subsequent examples will block on habitat package installation, awaiting license acceptance
execute 'hab license accept' unless skip_habitat

# 19 - old example did not match required syntax
habitat_sup 'default' do
  listen_ctl '0.0.0.0:9632'
  listen_http '0.0.0.0:9631'
  listen_gossip '0.0.0.0:9938'
end unless skip_habitat

# 20
hostname 'my-new-hostname' do
  action :set
end if false

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
end if false

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
package 'perl'

perl 'hello world' do
  code <<-EOH
    print "Hello world! From Chef and Perl.";
  EOH
end if false

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
end if false

# 34
ruby_block 'print_message' do
  block do
    puts 'This is a Ruby block in Chef!'
  end
  action :run # Default action
end

# 35
cron_svc = debian? ? 'cron' : 'crond'
service cron_svc do
  action %i(enable start)
end

# 36
sudo 'webadmin_apache' do
  user 'root'
  commands ['/bin/systemctl restart httpd']
  nopasswd true
  action :create
end if false

# 37
template '/tmp/ssh_known' do
  source 'default.erb' # 'index.html'
  mode '0644'
  action :create
end if false

# 38
timezone 'UTC' do
  action :set
end

# 39
user_ulimit 'tomcat' do
  filehandle_limit 8192
  filename 'tomcat_filehandle_limits.conf'
end if false

# 40
yum_repository 'rhel-repo' do
   reposdir '/tmp/'
   action :create
   make_cache false
end if rhel?



### Based on results 20241220 ###

skip_chef = true
chef_server = "https://chef.example.com"

# 02 - supervisor not running... I don't know Habitat well enough to debug
# habitat_config 'default' do
#   config({
#     serveradmin: "admin@example.com",
#     serversignature: "On"
#   })
#
#   action :apply
# end

# 03
apt_update  'now' do
  action :update
end if debian?

package 'ksh'
ksh 'hello world' do
  code 'echo "Hello world"'
end if false

# 04
inspec_input 'timezone_input' do
  source ({ timezone: 'UTC' })
  action :add
end

# 05 - rhel does not have a csh package
apt_update 'now' do
  action :update
end

package 'tcsh'
csh 'run_example_script' do
  code 'echo "Hello from CSH"'
  action :run
end if false

# 06
package 'python36' if rhel?

python 'hello_world' do
  code <<-EOH
    print("Hello, world! From Chef and Python.")
  EOH
  interpreter 'python3'
  action :run
end if false

# 07
# FreeBSD

# 08-12 (19.0.61+)
if Chef::VERSION >= Chef::VersionString.new("19.0.61") && !skip_chef
  # Docs are wrong, see
  #  https://github.com/chef/cheffish/blob/9152b5ff275461db322ba6fddd2444d0038bdee6/lib/cheffish/base_properties.rb#L16C15-L16C26
  #  https://github.com/chef/cheffish/blob/9152b5ff275461db322ba6fddd2444d0038bdee6/lib/cheffish.rb#L8
  chef_client 'example-client' do
    chef_server ({
      chef_server_url: chef_server,
      options: {
      }
    })
    admin true
    complete true
    action :create
  end

  # Create a group named 'developers' on the Ubuntu machine
  chef_group 'developers' do
    action :create
  end

  # Docs are wrong, see
  #  https://github.com/chef/cheffish/blob/9152b5ff275461db322ba6fddd2444d0038bdee6/lib/cheffish/node_properties.rb
  chef_node 'example-node' do
    chef_environment 'production'
    attributes ({
      "httpd" => {
        "listen" => 80
      }
    })
    tags "webserver"
    run_list ["recipe[httpd::configure]"]
    action :create
  end

  # Docs wrong, see
  #  https://github.com/chef/cheffish/blob/9152b5ff275461db322ba6fddd2444d0038bdee6/lib/chef/resource/chef_organization.rb
  chef_organization 'organization_name' do
    full_name 'Organization Ltd.'
    action :create
  end

  chef_user 'john_doe' do
    display_name 'John Doe'
    admin true
    email 'john@example.com'
    password 'hashed_password_here'
    action :create
  end

  chef_role 'webserver' do
    description 'Role for web servers'
    default_attributes(
      'apache' => {
        'port' => 80
      }
    )
    env_run_lists ({
      'production' => [
        'role[base]',
        'recipe[apache]'
      ]
    })
    default_attributes ({
      "httpd" => {
        "listen" => 80
      }
    })
    action :create
  end
end

# 14 - resource does not exist, see habitat_sup in rc1 example 19
=begin
habitat_sup_linux 'default' do
  action :run
  # Configuration options
  service 'default'   # Specify the service name, which will be used for supervision
  ring 'default'      # The name of the Habitat ring (cluster) to join
  topology 'leader'   # Topology options: 'leader', 'standalone', or 'federation'
  gossip 'default'    # The name of the gossip service
  # Set the configuration options (adjust as needed)
  config do
    {
      'peer' => 'default',       # Example configuration option
      'listen' => '0.0.0.0:9631' # Example configuration option
    }
  end
end
= end

# 15
apt_update  'now' do
  action :update
end

package 'subversion'
directory '/tmp/project'

subversion 'checkout_project_code' do
  repository "http://svn.apache.org/repos/asf/couchdb/trunk"
  destination '/tmp/project'
  revision 'HEAD'
  action :sync
end

# 16
file '/usr/bin/my_custom_script'

systemd_unit 'my_custom_service.service' do
  content(
    {
      'Unit' => {
        'Description' => 'My Custom Service',
        'After' => 'network.target',
      },
      'Service' => {
        'ExecStart' => '/usr/bin/my_custom_script.sh',
        'Restart' => 'on-failure',
      },
      'Install' => {
        'WantedBy' => 'multi-user.target',
      },
    }
  )
  action [:create, :enable, :start]
end if false

# 17 - Cannot work, requires a local RPM package. This is not Yum
# rpm_package 'Install crond' do
#   package_name 'crond'
#   action :install
# end

# 18 - adjusted to dynamically adjust to distributions
route '10.0.1.10/32' do
  gateway node['network']['default_gateway']
  device node['network']['default_interface']
end

# 19 - not available for rhel
locale 'set system locale' do
  lang 'en_US.UTF-8'
end if debian? and false

# 20 - package `cron`` does not exist on RHEL, switched to anacron
package 'anacron' if debian?
package 'cronie' if rhel?

# 21
# pacman_package

# 22
remote_directory '/tmp/abc/' do
  source 'abc'
  owner 'root'
  group 'root'
  mode '0755'
  files_owner 'root'
  files_group 'root'
  files_mode '0644'
  action :create
end

# 23
script 'run_custom_script' do
  interpreter 'bash'
  code "echo 'This is a custom script in Chef!'"
  action :run
end if false

# 24
# solaris_package

# 25
if platform_family? 'rhel'
  # "No installation candidate" = Snap not installed (needs EPEL on RHEL)
  yum_repository 'epel' do
    description 'Extra Packages for #{yum_epel_release} - $basearch'
    mirrorlist "https://mirrors.fedoraproject.org/mirrorlist?repo=epel-8&arch=$basearch"
    gpgkey "https://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8"
  end

  yum_package 'snapd'
  execute 'systemctl enable --now snapd.socket'
end
snap_package 'ponysay'

# 26
# paludis_package

# 27
# portage_package (Gentoo)

# 28
yum_package 'httpd' do
  action :install
end

# 29
if platform_family? 'rhel'
  yum_repository 'epel' do
    description 'Extra Packages for #{yum_epel_release} - $basearch'
    mirrorlist "https://mirrors.fedoraproject.org/mirrorlist?repo=epel-8&arch=$basearch"
    gpgkey "https://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8"
  end
end

# 30
# zypper_package (SuSE)

# 31
# zypper_repository (SuSE)

# 32-34
if Chef::VERSION >= Chef::VersionString.new("19.0.61")
  chef_acl '/nodes/*' do
    rights :all, :users => 'jkeiser' # from examples in cheffish
    action :create
  end

  chef_container 'my_container' do
    action :create
  end

  chef_mirror 'mirror_chef_cookbooks' do
    path 'nodes/*'
    action :upload
  end
end
=end
