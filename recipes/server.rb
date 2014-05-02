#
# Cookbook Name:: teamcity
# Recipe:: server
#
# Copyright (C) 2014 Fabio Napoleoni
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Setup for teamcity
include_recipe 'teamcity::common'

# download teamcity and extract it into final location,
# using versions folder and symlinks to allow easy updates
ark 'server' do
  url node[:teamcity][:server][:download_url]
  checksum node[:teamcity][:server][:checksum]
  version node[:teamcity][:server][:version]
  owner node[:teamcity][:system][:user]
  group node[:teamcity][:system][:group]
  prefix_root node[:teamcity][:system][:home]
  prefix_home node[:teamcity][:system][:home]
  action :install
end

# Create data directory in the given path
directory node[:teamcity][:server][:data_dir] do
  owner node[:teamcity][:system][:user]
  group node[:teamcity][:system][:group]
end

# configure using templates, current configuration is the default one with port customization
template "#{node[:teamcity][:server][:path]}/conf/server.xml" do
  source 'server.xml.erb'
  owner node[:teamcity][:system][:user]
  group node[:teamcity][:system][:group]
end

# Configure server startup variables
template "#{node[:teamcity][:server][:path]}/bin/teamcity-init.sh" do
  source 'teamcity-init.sh.erb'
  owner node[:teamcity][:system][:user]
  group node[:teamcity][:system][:group]
  mode '0644'
end

# create init script for standalone server
template '/etc/init.d/teamcity-server' do
  source 'teamcity-server.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

# service enable and start
service 'teamcity-server' do
  action [:enable, :start]
end
