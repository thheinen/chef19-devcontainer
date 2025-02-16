freebsd_package 'nginx' do
  action :install
  version '1.18.0'
  timeout 300
  retries 3
  retry_delay 5
  not_if 'pkg info -q nginx'
end
