paludis_package 'nginx' do
  action :install
end

portage_package 'links' do
  action :install
end
