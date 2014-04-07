# System user configuration
default[:teamcity][:system][:user] = 'teamcity'
default[:teamcity][:system][:group] = 'teamcity'
default[:teamcity][:system][:home] = '/opt/teamcity'
default[:teamcity][:system][:generate_keys] = false

# Teamcity archive and checksum
default[:teamcity][:server][:version] = '8.1.1'
default[:teamcity][:server][:base_url] = 'http://download-cf.jetbrains.com/teamcity'
default[:teamcity][:server][:download_url] = "#{node[:teamcity][:server][:base_url]}/TeamCity-#{node[:teamcity][:server][:version]}.tar.gz"
default[:teamcity][:server][:checksum] = 'edfa219b2f208ff41ceed1d79b962208e81a3c33bfbbe6781eb2bb111e4ec903' # For v 8.1.1
# Server installation attributes
default[:teamcity][:server][:port] = 8111
default[:teamcity][:server][:listen_address] = '127.0.0.1'
default[:teamcity][:server][:path] = "#{node[:teamcity][:system][:home]}/server"
# Server resources tuning
default[:teamcity][:server][:heap_space] = '1024m'
default[:teamcity][:server][:perm_gen_space] = '270m'
# Additional tunable attributes
default[:teamcity][:server][:server_name] = "build.#{node[:domain]}"
default[:teamcity][:server][:data_dir] = "#{node[:teamcity][:system][:home]}/data"

# Database credentials used in mysql recipe
default[:teamcity][:server][:mysql][:user] = 'teamcity'
default[:teamcity][:server][:mysql][:password] = 'teamcity'
default[:teamcity][:server][:mysql][:database] = 'teamcity'
default[:teamcity][:server][:mysql][:host] = 'localhost'
