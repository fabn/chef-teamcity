#
# Cookbook Name:: teamcity
# Recipe:: common
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


if node[:java][:install_flavor] == 'openjdk'
  Chef::Log.info 'You are using openjdk java. While it works, remember that is not officially supported by Teamcity'
end

include_recipe 'java'

# create system user for running teamcity stuff
user_account node[:teamcity][:system][:user] do
  comment 'User for running teamcity stuff'
  home node[:teamcity][:system][:home]
  manage_home true
  ssh_keygen node[:teamcity][:system][:generate_keys]
end
