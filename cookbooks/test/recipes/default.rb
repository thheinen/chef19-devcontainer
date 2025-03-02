######
# Accessible 2 #2

user 'cbtest' do
  comment 'system guy'
  system true
  shell '/bin/false'
end

######
# Accessible 2 #3-11

if platform_family? 'rhel'
  selinux_install 'selinux' do
    action :install
    packages %w(make policycoreutils selinux-policy selinux-policy-targeted selinux-policy-devel libselinux-utils setools-console)
  end

  user 'ctest' do
    system true
  end

  selinux_user 'ctest' do
    level 's0'
    range 's0'
    roles %w(sysadm_r staff_r)
  end

  selinux_login 'ctest' do
    user 'user_u'
    range 's0'
    action :manage
  end

  file '/tmp/foo.txt'

  selinux_fcontext '/tmp/foo.txt' do
    secontext 'samba_share_t'
    file_type 'a'
    action :add
  end

  selinux_permissive 'httpd_t' do
    action :add
  end

  selinux_module 'my_policy_module' do
    base_dir '/etc/selinux/local/'
    content <<-EOF
      module custom_module 1.0;
      echo 'Hello Test';
    EOF
    action :remove
  end

  selinux_port '5678' do
    protocol 'tcp'
    secontext 'http_port_t'
  end

  selinux_state 'enforcing' do
    action :enforcing
  end

  selinux_boolean 'ssh_keysign' do
    value true
    persistent false
    action :set
  end
end

######
# Accessible 2 #12

ssh_known_hosts_entry 'gitlab.com' do
  file_location '/etc/ssh/ssh_known_hosts'
  action :create
end

######
# Accessible 2 #13-17

if platform_family? 'rhel'
  rhsm_register 'register_with_rhsm' do
    username ENV['RHEL_USER']
    password ENV['RHEL_PW']
    auto_attach true
    action :register
  end

  rhsm_subscription 'attach_subscription' do
    pool_id '2c94582e918fd1090191db3a9e083436'
    action :attach
  end

  rhsm_repo 'rhel-9-server-rpms' do
    repo_name 'rhel-atomic-7-cdk-3.11-rpms'
    action :enable
  end

  rhsm_errata 'apply_rhsa' do
    errata_id 'RHSA-2014:1293'
    action :install
  end

  rhsm_errata_level 'RHSA-2014' do
    errata_level 'moderate'
    action :install
  end
end

######
# Accessible 2 #18

swap_file '/swapfile' do
  size 524 # Size in MB
  persist false
  action :create
end

######
# Accessible 2 #19

sysctl 'net.ipv4.ip_forward' do
  value '1'
  action :apply
end

######
# Accessible 2 #20-22 (19.0.61+)

if Chef::VERSION >= Chef::VersionString.new("19.0.61")
  chef_container 'my_container' do
    action :create
  end

  chef_data_bag 'data_bag' do
    action :create
  end

  chef_data_bag_item 'data_bag/id' do
    raw_data({
      "feature" => true
    })
  end

  chef_environment 'dev' do
    description 'Dev Environment'
    default_attributes({ "dev" => 1 })
  end
end

######
# Accessible 2 #23

directory '/tmp/chef-repo'

cookbook_file '/tmp/chef-repo/config.conf' do
  source 'config.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

######
# Accessible 2 #24

#group 'hab'
#user 'hab' do # does not pass idempotency checks?
#  gid 'hab'
#  not_if 'id hab'
#end

habitat_install

directory '/hab/accepted-licenses' do
  recursive true
end

file '/hab/accepted-licenses/habitat'

# Timeout 1625-
habitat_package 'core/httpd' do
  channel 'stable'       # Channel from which to install
  version '2.4.51'       # Optional: Specify version, or omit to install the latest version
  action  :install       # Action to install the package
end

######
# Accessible 2 #25

habitat_install

directory '/hab/accepted-licenses' do
  recursive true
end

file '/hab/accepted-licenses/habitat'

habitat_service 'core/httpd' do
  action :unload  # Stops and unloads the service
end

######
# Accessible 2 #26

alternatives 'python' do
  link '/usr/bin/python'
  action :remove
end

######
# Accessible 2 #27

inspec_waiver 'web_server_security' do
  control 'security-123'
  expiration '2024-06-30'
  justification 'Waiver granted due to ongoing security patch deployment.'
  run_test true
  action :add
end

################################################################################

######
# Not Accessible #2-3

# 20241220 TH: Outdated Cheffish gem (7.1.7 instead of 7.1.8)

######
# Not Accessible #6

=begin
group 'hab'
user 'hab' do
  comment 'Habitat User'
  home '/home/hab'
  group 'hab'
  shell '/bin/bash'
  manage_home true
  action :create
end
=end

#habitat_install
#habitat_package 'core/nginx'

######
# Not Accessible #5

#directory '/hab/accepted-licenses'
#file '/hab/accepted-licenses/habitat'
#
#habitat_service 'core/nginx unload' do
#  service_name 'core/nginx'
#  action :unload
#end

######
# Not Accessible #4

=begin
habitat_config 'default' do
  # Configurations for the Habitat service
  config({
    'service' => {
      'myapp' => {
        'binding_mode' => 'relaxed',
        'port' => 8080,
        'log_level' => 'info'
      }
    }
  })

  # Gateway authentication token (if needed)
  gateway_auth_token 'your-gateway-auth-token'

  # Service group name (default is 'default')
  service_group 'mygroup.prod'

  # User to run the service
  user 'hab'

  # Apply the configuration (default action)
  action :apply
end
=end


######
# Not Accessible #7

apt_update  'now' do
  action :update
end if debian?

package 'ksh'
ksh 'hello world' do
  code 'echo "Hello world"'
end

######
# Not Accessible #8

# Works, if the referenced binary is installed...
alternatives 'python' do
  link      '/usr/bin/python'         # Symbolic link path
  link_name 'python'                  # Name of the alternative

  path '/usr/bin/python' + value_for_platform(
    'ubuntu' => {
      '20.04' => '3.8',
      '22.04' => '3.10'
    },
    'rhel' => {
      '8.9' => '3.10' }
  )

  priority  200                       # Priority of this alternative
  action    :install                  # Install this alternative

  only_if { platform_family? 'debian' }
end

######
# Not Accessible #9

inspec_input 'timezone_input' do
  source ( { timezone: 'UTC' } )
  action :add
end

######
# Not Accessible #10

# 20241220 TH: Syntax wrong, works, no "Cannot find a resource" error
directory '/etc/inspec'

inspec_waiver 'web_server_security' do
  control 'security-123'
  justification 'Waiver granted due to ongoing security patch deployment.'
  expiration '2024-06-30'
  action :add
end

######
# Not Accessible #11

# 20241220 TH: Syntax wrong, works, no "Cannot find a resource" error
inspec_waiver_file_entry 'web_server_security' do
  control 'security-123'
  justification 'Waiver granted due to ongoing security patch deployment.'
  expiration '2024-06-30'
  file_path '/etc/inspec/waivers.yml'
  action :add
end

######
# Not Accessible #12

# 20241220 TH: Issue in apt_package prevents installation of prerequisite
apt_update 'now' do
  action :update
end

package 'tcsh' if platform_family? 'rhel'
package 'csh' if platform_family? 'debian'

csh 'run_example_script' do
  code 'echo "Hello from CSH"'
  action :run
end

######
# Not Accessible #13

# 20241220 TH: Works without modifications
directory '/tmp/chef-repo'

cookbook_file '/tmp/chef-repo/config.conf' do
  source 'config.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

#####
# Not Accessible #23

apt_update  'now' do
  action :update
end

package 'subversion'
directory '/tmp/project'

# 20241220 Needs with an existing repo (GitHub != SVN)
subversion 'checkout_project_code' do
  repository "http://svn.apache.org/repos/asf/couchdb/trunk"
  destination '/tmp/project'
  revision 'HEAD'
  action :sync
end

#####
# Not Accessible #25

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
end

######
# Not Accessible #26

route '10.0.1.10/32' do
  gateway node['network']['default_gateway']

  device node['network']['default_interface']
end

######
# Not Accessible #27 (CONFIRMED)

# 20241228 TH: file[Updating system locale] (test::default line 155) had an error: ArgumentError: wrong number of arguments (given 1, expected 0)
#locale 'set system locale' do
#  lang 'en_US.UTF-8'
#end

######
# Not Accessible #28

package 'nginx' # cron does not exist on RHEL

######
# Not Accessible #29 -> not Ubuntu/RedHat

######
# Not Accessible #30

# 20241228 TH: Chef::Exceptions::FileNotFound: cookbook test has no directory files/default/index.html
#remote_directory '/tmp/abc/' do
#  source 'index.html' # '/home/ec2-user/.chef/chef-repo/cookbooks/cis_rhel_7_benchmark_v3.1.1/files/default/index.html' # Directory in the cookbook
#  owner 'root' # Owner of the directory
#  group 'root' # Group of the directory
#  mode '0755' # Permissions for the directory
#  files_owner 'root' # Owner of the files
#  files_group 'root' # Group of the files
#  files_mode '0644' # Permissions for the files
#  action :create # Action to create the directory and copy the files (default)
#end

######
# Not Accessible #31

script 'run_custom_script' do
  interpreter 'bash' # Specify a custom interpreter
  code "echo 'This is a custom script in Chef!'" # Custom script code
  action :run # Default action
end

######
# Not Accessible #32: Not Ubuntu/RedHat

######
# Not Accessible #33

# "No installation candidate" = Snap not installed (needs EPEL on RHEL)
if platform_family? 'rhel'
  yum_repository 'epel' do
    description 'Extra Packages for #{yum_epel_release} - $basearch'
    mirrorlist "https://mirrors.fedoraproject.org/mirrorlist?repo=epel-8&arch=$basearch"
    gpgkey "https://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8"
  end

  yum_package 'snapd'
  execute 'systemctl enable --now snapd.socket'
end
snap_package 'ponysay'

######
# Not Accessible #34-35: Not Ubuntu/RedHat

######
# Not Accessible #36

# 20241220 TH forgot a ",target_mode: true" (CONFIRMED)
if platform_family? 'rhel'
  yum_package 'httpd' do
    action :install
  end
end

######
# Not Accessible #37

if platform_family? 'rhel'
  yum_repository 'epel' do
    description 'Extra Packages for #{yum_epel_release} - $basearch'
    mirrorlist "https://mirrors.fedoraproject.org/mirrorlist?repo=epel-8&arch=$basearch"
    gpgkey "https://download.fedoraproject.org/pub/epel/RPM-GPG-KEY-EPEL-8"
  end
end

######
# Not Accessible #38-39: Not Ubuntu/RedHat

######
# Not Accessible #40-43: Outdated Cheffish Gem

######
# Others / Regressions

timezone 'UTC' do
  action :set
end

if platform_family? 'rhel'
  selinux_module 'my_policy_module' do
    base_dir '/etc/selinux/local/'
    content <<-EOF
      module custom_module 1.0;
      echo 'Hello Test';
    EOF
    action :remove
  end
end
