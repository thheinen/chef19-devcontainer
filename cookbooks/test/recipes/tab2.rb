### Based on results 20241220 ###

skip_habitat = true

# 02
user 'cbtest' do
  comment 'system guy'
  system true
  shell '/bin/false'
end

# 03
selinux_install 'selinux' do
  action :install
  packages %w(make policycoreutils selinux-policy selinux-policy-targeted selinux-policy-devel libselinux-utils setools-console)
end if rhel?

# 04
user 'ctest' do
  system true
end if rhel?

selinux_user 'ctest' do
  level 's0'
  range 's0'
  roles %w(sysadm_r staff_r)
end if rhel?

# 05
selinux_login 'ctest' do
  user 'user_u'
  range 's0'
  action :manage
end if rhel?

# 06
file '/tmp/foo.txt' if rhel?

selinux_fcontext '/tmp/foo.txt' do
  secontext 'samba_share_t'
  file_type 'a'
  action :add
end if rhel?

# 07
selinux_permissive 'httpd_t' do
  action :add
end if rhel?

# 08
selinux_module 'my_policy_module' do
  base_dir '/etc/selinux/local/'
  content <<-EOF
    module custom_module 1.0;
    echo 'Hello Test';
  EOF
  action :remove
end if rhel?

# 09
selinux_port '5678' do
  protocol 'tcp'
  secontext 'http_port_t'
end if rhel?

# 10
selinux_state 'enforcing' do
  action :enforcing
end if rhel?

# 11
selinux_boolean 'ssh_keysign' do
  value true
  persistent false
  action :set
end if rhel?

# 12
ssh_known_hosts_entry 'gitlab.com' do
  file_location '/etc/ssh/ssh_known_hosts'
  action :create
end

# 13
rhsm_register 'register_with_rhsm' do
  username ENV['RHEL_USER']
  password ENV['RHEL_PW']
  auto_attach true
  action :register
end if rhel?

# 14
rhsm_subscription 'attach_subscription' do
  pool_id '2c94582e918fd1090191db3a9e083436'
  action :attach
end if rhel?

# 15
rhsm_repo 'rhel-9-server-rpms' do
  repo_name 'rhel-atomic-7-cdk-3.11-rpms'
  action :enable
end if rhel?

# 16
rhsm_errata 'apply_rhsa' do
  errata_id 'RHSA-2014:1293'
  action :install
end if rhel?

# 17
rhsm_errata_level 'RHSA-2014' do
  errata_level 'moderate'
  action :install
end if rhel?

# 18
swap_file '/swapfile' do
  size 524 # Size in MB
  persist false
  action :create
end

# 19
sysctl 'net.ipv4.ip_forward' do
  value '1'
  action :apply
end

# 20-22 (19.0.61+)
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

# 23
directory '/tmp/chef-repo'

cookbook_file '/tmp/chef-repo/config.conf' do
  source 'config.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

# 24
habitat_install unless skip_habitat

execute 'hab license accept' unless skip_habitat

habitat_package 'core/httpd' do
  channel 'stable'       # Channel from which to install
  version '2.4.51'       # Optional: Specify version, or omit to install the latest version
  action  :install       # Action to install the package
end unless skip_habitat

# 25
habitat_service 'core/httpd' do
  action :load
end unless skip_habitat

# 26
alternatives 'python' do
  link '/usr/bin/python'
  action :remove
end

# 27
inspec_waiver 'web_server_security' do
  control 'security-123'
  expiration '2024-06-30'
  justification 'Waiver granted due to ongoing security patch deployment.'
  run_test true
  action :add
end

# 28
inspec_waiver_file_entry 'web_server_security_waiver' do
  control 'security-123'
  expiration '2024-06-30'
  file_path '/etc/chef/inspec_waivers.yml'
  justification 'Waiver granted due to ongoing security patch deployment.'
  run_test true
  action :add
end
