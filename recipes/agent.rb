#
# Cookbook Name:: teamcity
# Recipe:: agent
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

# Configure user for running agent
include_recipe 'teamcity::common'

if node[:teamcity][:agent][:install_method] == 'sources'
  # Install server and fetch agent files from distribution
  include_recipe 'teamcity::server'
  # Copy agent files from server distribution
  execute 'copy agent from server sources' do
    command "cp -a #{node[:teamcity][:server][:path]}/buildAgent #{node[:teamcity][:agent][:path]}"
    not_if "test -d #{node[:teamcity][:agent][:path]}"
  end
else
  # Download agent distribution from a running server
  ark 'teamcity-agent' do
    # This is used as final folder name by ark
    name 'agent'
    url node[:teamcity][:agent][:agent_archive_url]
    path node[:teamcity][:system][:home]
    owner node[:teamcity][:system][:user]
    group node[:teamcity][:system][:group]
    action :put
  end
end

# fetch old token if already set to avoid unauthorized agents at every chef run
ruby_block 'read existing token from agent configuration' do
  block do
    begin
      current_conf = ::File.read("#{node[:teamcity][:agent][:path]}/conf/buildAgent.properties")
      node.set[:teamcity][:agent][:token] = current_conf.match(/^authorizationToken=(.*)$/)[1]
    rescue
      # if file doesn't exist do not set the attribute
    end
  end
end

# configure the agent using templates
directory "#{node[:teamcity][:agent][:path]}/conf" do
  # redundant, should be created by above steps
  user node[:teamcity][:system][:user]
  group node[:teamcity][:system][:group]
end

# Agent configuration file
template "#{node[:teamcity][:agent][:path]}/conf/buildAgent.properties" do
  source 'buildAgent.properties.erb'
  user node[:teamcity][:system][:user]
  group node[:teamcity][:system][:group]
  mode '0640'
end

# create init script for teamcity agent
template '/etc/init.d/teamcity-agent' do
  source 'teamcity-agent.erb'
  owner 'root'
  group 'root'
  mode '0755'
end

# service start
service 'teamcity-agent' do
  action [:enable, :start]
end
