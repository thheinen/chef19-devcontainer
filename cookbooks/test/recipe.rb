
# Add timezone input for compliance phase
#inspec_input 'timezone_input' do
#  input 'UTC'  # Default timezone value
#  source '/etc/timezone'  # Path to the system's timezone file
#  action :add  # Adds this input to the compliance phase
#end

directory '/etc/inspec'

inspec_waiver 'web_server_security' do
  control 'security-123'
  justification 'Waiver granted due to ongoing security patch deployment.'
  expiration '2024-06-30'
  action :add
end

directory '/tmp/inspec'

# Add a waiver entry to a specific waiver file
inspec_waiver_file_entry 'web_server_security' do
  control 'security-123'
  justification 'Waiver granted due to ongoing security patch deployment.'
  expiration '2024-06-30'
  file_path '/etc/inspec/waivers.yml'
  action :add
end

#user 'hab' do
#  comment 'Habitat User'
#  home '/home/hab'
#  group 'hab'
#  shell '/bin/bash'
#  manage_home true
#  action :create
#
#  not_if 'id hab'
#end
#habitat_install

habitat_package 'core/nginx'
habitat_service 'core/nginx'

habitat_config 'nginx.default' do
  config({
    worker_count: 2,
    http: {
      keepalive_timeout: 120
    }
  })
end

habitat_service 'core/nginx unload' do
  service_name 'core/nginx'
  action :unload
end

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

#directory '/tmp/chef-repo'
cookbook_file '/tmp/chef-repo/config.conf' do
  source 'config.conf'
  owner 'root'
  group 'root'
  mode '0644'
  action :create
end

