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

package 'tcsh'
csh 'run_example_script' do
  code 'echo "Hello from CSH"'
  action :run
end

# 06
package 'python36' if rhel?

python 'hello_world' do
  code <<-EOH
    print("Hello, world! From Chef and Python.")
  EOH
  interpreter 'python3'
  action :run
end

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

# 19 - not available for rhel
locale 'set system locale' do
  lang 'en_US.UTF-8'
end if debian?

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
