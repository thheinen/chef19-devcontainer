zypper_repository 'vlc' do
  baseurl 'https://download.videolan.org/pub/vlc/'
  path '/SuSE/15.6/'
  gpgcheck false
end

zypper_package 'vlc' do
  action :install
end
