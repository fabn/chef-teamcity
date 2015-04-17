# System user configuration
default[:teamcity][:system][:user] = 'teamcity'
default[:teamcity][:system][:group] = 'teamcity'
default[:teamcity][:system][:home] = '/opt/teamcity'
default[:teamcity][:system][:generate_keys] = false

# Teamcity archive and checksum
default[:teamcity][:server][:version] = '9.0.3'
default[:teamcity][:server][:base_url] = 'http://download-cf.jetbrains.com/teamcity'
default[:teamcity][:server][:download_url] = "#{node[:teamcity][:server][:base_url]}/TeamCity-#{node[:teamcity][:server][:version]}.tar.gz"
default[:teamcity][:server][:checksum] = 'cacef22cf53506346078c05ff9c12dd5bd773c90596cf72fbf4ff49ff8493d1a' # For v 9.0.3
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

# Attributes needed for teamcity agent installation
default[:teamcity][:agent][:listen_port] = 9090
default[:teamcity][:agent][:user] = node[:teamcity][:system][:user]
default[:teamcity][:agent][:group] = node[:teamcity][:system][:group]
default[:teamcity][:agent][:home] = node[:teamcity][:system][:home]
default[:teamcity][:agent][:path] = "#{node[:teamcity][:agent][:home]}/agent"
default[:teamcity][:agent][:install_method] = 'sources' # can be either sources or server
default[:teamcity][:agent][:server_url] = 'http://localhost:8111'
default[:teamcity][:agent][:agent_archive_url] = "#{node[:teamcity][:agent][:server_url]}/update/buildAgent.zip"

# Agent configuration parameters
default[:teamcity][:agent][:system_properties] = {}
default[:teamcity][:agent][:environment_variables] = {}
