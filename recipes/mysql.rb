#
# Cookbook Name:: teamcity
# Recipe:: mysql
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

# Install server
include_recipe 'teamcity::server'

ark 'mysql-connector' do
  url 'http://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.30.tar.gz'
  path "#{node[:teamcity][:server][:data_dir]}/lib/jdbc"
  action :cherry_pick
  creates 'mysql-connector-java-5.1.30/mysql-connector-java-5.1.30-bin.jar'
  owner node[:teamcity][:system][:user]
  group node[:teamcity][:system][:group]
end

# Required to create users
include_recipe 'mysql-chef_gem'

# MySQL administrative credentials used to create an user
admin_credentials = node[:teamcity][:server][:mysql][:credentials]
# Default if using mysql::server recipe
admin_credentials ||= {
    host: 'localhost',
    username: 'root',
    password: node[:mysql][:server_root_password]
}

# Create teamcity empty database
mysql_database node[:teamcity][:server][:mysql][:user] do
  connection admin_credentials
  action :create
end

# Create teamcity user
mysql_database_user node[:teamcity][:server][:mysql][:user] do
  connection admin_credentials
  password node[:teamcity][:server][:mysql][:password]
  database_name node[:teamcity][:server][:mysql][:database]
  host node[:teamcity][:server][:mysql][:host]
  action :grant
end

# Server may not be started yet, so config directory may not exist
directory "#{node[:teamcity][:server][:data_dir]}/config" do
  owner node[:teamcity][:system][:user]
  group node[:teamcity][:system][:group]
end

template "#{node[:teamcity][:server][:data_dir]}/config/database.properties" do
  source 'database.mysql.properties.erb'
  owner node[:teamcity][:system][:user]
  group node[:teamcity][:system][:group]
  mode '0600'
  notifies :restart, 'service[teamcity-server]'
end
