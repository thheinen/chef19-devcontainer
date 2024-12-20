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

# 20241220 TH: Issue in apt_package prevents installation of prerequisite
#apt_update  'now' do
#  action :update
#end
#
#package 'ksh'

# 20241220 TH: HEREDOC syntax broken
# ksh 'hello world' do
#   code 'echo "Hello world"'
# end

######
# Not Accessible #8

# 20241220 TH: Works, if the referenced binary is installed...
alternatives 'python' do
  link      '/usr/bin/python'         # Symbolic link path
  link_name 'python'                  # Name of the alternative
  path      '/usr/bin/python3.10'     # Path to the alternative
  priority  200                       # Priority of this alternative
  action    :install                  # Install this alternative

  only_if { platform_family? 'debian' }
end

######
# Not Accessible #9

# 20241220 TH: Error about "include_input" being nil (CONFIRMED)
#file '/etc/timezone' do
#  content 'UTC'  # Set the timezone content to 'UTC'
#  mode '0644'  # Ensure the file is readable by all, writable by owner
#  owner 'root'  # Ensure the file is owned by root
#  group 'root'  # Ensure the file belongs to root group
#  action :create  # Create the file if it does not exist
#end
#
#inspec_input 'timezone_input' do
#  input 'UTC'  # Default timezone value
#  source '/etc/timezone'  # Path to the system's timezone file
#  action :add  # Adds this input to the compliance phase
#end

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
#apt_update 'now' do
#  action :update
#end
#
#apt_package 'csh'

#csh 'run_example_script' do
#  code 'echo "Hello from CSH"'
#  action :run
#end

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

# 20241220 TH: 
#apt_update  'now' do
#  action :update
#end
#
#package 'subversion'
#
#directory '/tmp/project'
#
# 20241220 TH Needs with an existing repo (GitHub != SVN), still CONFIRMED
#subversion 'checkout_project_code' do
#  repository "http://svn.apache.org/repos/asf/couchdb/trunk"
#  destination '/tmp/project'
#  revision 'HEAD' # Check out revision 1234
#  action :sync
#end

#####
# Not Accessible #25

# 20241220 TH: Works without modifications
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

# 20241220 TH: Works without modifications (except for device/gateway)
route '10.0.1.10/32' do
  gateway '172.31.16.1'

  device 'ens5' if platform_family? 'debian'
  device 'eth0' if platform_family? 'rhel'
end

######
# Not Accessible #27 (CONFIRMED)

# 20241220 TH: `locale -a: command not found` -> Issue with shell_out maybe?
#locale 'set system locale' do
#  lang 'en_US.UTF-8'
#end

######
# Not Accessible #28

# 20241220 TH: On Ubuntu, this package is "cron" - no "flush_cache" error. RedHat CONFIRMED
#package 'cron' do
#  action :install
#end

######
# Not Accessible #29 -> not Ubuntu/RedHat

######
# Not Accessible #30

# 20241220 TH: 
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

# 20241220 TH: HEREDOC syntax broken
#script 'run_custom_script' do
#  interpreter 'bash' # Specify a custom interpreter
#  code "echo 'This is a custom script in Chef!'" # Custom script code
#  action :run # Default action
#end

######
# Not Accessible #32: Not Ubuntu/RedHat

######
# Not Accessible #33

# 20241220 TH Always "No installation candidate" (CONFIRMED)
#snap_package 'ponysay'

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
  yum_repository 'metadata_repo' do
    description 'Repository with metadata expiration'
    baseurl 'https://cdn.redhat.com/content/dist/rhel/entitlement-6/releases/$releasever/$basearch/scalablefilesystem/source/SRPMS'
    gpgcheck true
    # gpgkey 'http://repo.example.com/RPM-GPG-KEY'
    metadata_expire '7d'
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