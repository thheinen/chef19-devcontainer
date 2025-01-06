### Based on results 20241220 ###

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
end

# 04
inspec_input 'timezone_input' do
  source ({ timezone: 'UTC' })
  action :add
end

# 05 - rhel does not have a csh package
apt_update 'now' do
  action :update
end

package 'tcsh' if platform_family? 'rhel'
package 'csh' if platform_family? 'debian'

csh 'run_example_script' do
  code 'echo "Hello from CSH"'
  action :run
end

# 06 - some quoting issue (TODO)
# python 'hello_world' do
#   code <<-EOH
#     print("Hello, world! From Chef and Python.")
#   EOH
#   action :run
# end

# 07
# FreeBSD

# 08-12 (19.0.61+)
if Chef::VERSION >= Chef::VersionString.new("19.0.61")
  chef_client 'example-client' do
    chef_server 'https://chef-server.example.com/organizations/my_org'
    admin true  # Optional: Make this client an API client
    complete true # Optional: Define the client completely
    ignore_failure false # Optional: Do not ignore failure by default
    action :create # Default action, creates a client
  end

  # Create a group named 'developers' on the Ubuntu machine
  chef_group 'developers' do
    action :create
  end

  chef_node 'example-node' do
    chef_environment 'production'
    default_attributes({
      'mysql' => {
        'version' => '5.7'
      }
    })
    normal_attributes({
      'app' => {
        'name' => 'my_app'
      }
    })
    action :create
  end

  chef_organization 'name' do
    attribute 'value' # Set properties here
    action :action   # Define action here
  end

  chef_user 'john_doe' do
    shell '/bin/bash'
    comment 'John Doe - System Admin'
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
    env_run_lists [
      'role[base]',
      'recipe[apache]'
    ]
    ignore_failure true
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
=end

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
end

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

# 19
locale 'set system locale' do
  lang 'en_US.UTF-8'
end

# 20 - package `cron`` does not exist on RHEL, switched to anacron
package 'anacron'

# 21
# pacman_package

# 22 - not working (TODO)
# remote_directory '/tmp/abc/' do
#   source 'index.html' # '/home/ec2-user/.chef/chef-repo/cookbooks/cis_rhel_7_benchmark_v3.1.1/files/default/index.html' # Directory in the cookbook
#   owner 'root' # Owner of the directory
#   group 'root' # Group of the directory
#   mode '0755' # Permissions for the directory
#   files_owner 'root' # Owner of the files
#   files_group 'root' # Group of the files
#   files_mode '0644' # Permissions for the files
#   action :create # Action to create the directory and copy the files (default)
# end

# 23
script 'run_custom_script' do
  interpreter 'bash'
  code "echo 'This is a custom script in Chef!'"
  action :run
end

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
    rights [:read]
    users ['user1']
    action :add
  end

  chef_container 'my_container' do
    action :create
  end

  chef_mirror 'mirror_chef_cookbooks' do
    source 'https://my-mirror-server.com/cookbooks/my_cookbook-1.0.0.tar.gz'
    destination '/tmp/'
    action :sync
  end
end
