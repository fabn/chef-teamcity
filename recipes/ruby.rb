#
# Cookbook Name:: teamcity
# Recipe:: ruby
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

# include common recipe to create user
include_recipe 'teamcity::common'

# Don't create home directory for rbenv user
node.set[:rbenv][:manage_home] = false

# Add teamcity user to the rbenv group
node.default[:rbenv][:group_users].push(node[:teamcity][:system][:user])

# Include rbenv recipes
include_recipe 'rbenv::default'
include_recipe 'rbenv::ruby_build'

# Used to configure global ruby interpreter
global_ruby = node[:teamcity][:agent][:global_ruby] || node[:teamcity][:agent][:rubies].last

# For each declared ruby, install it for teamcity user and install bundler
node[:teamcity][:agent][:rubies].each do |ruby|

  rbenv_ruby ruby do
    global ruby == global_ruby
    only_if { node[:teamcity][:agent][:build_tools].include?('ruby') }
  end

  rbenv_gem 'bundler' do
    ruby_version ruby
    only_if { node[:teamcity][:agent][:build_tools].include?('ruby') }
  end

end
