#
# Cookbook Name:: teamcity
# Recipe:: nginx
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

# Install nginx webserver
include_recipe 'nginx'

# Install a nginx virtual host which proxies to TC tomcat installation
template "#{node['nginx']['dir']}/sites-available/#{node[:teamcity][:server][:server_name]}" do
  source 'nginx.conf.erb'
  mode '0644'
end

# enable the site if not already enabled
nginx_site node[:teamcity][:server][:server_name]

