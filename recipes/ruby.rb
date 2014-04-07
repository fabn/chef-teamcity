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

# Needed to build rubies
include_recipe 'ruby_build'
# Needed to use LRWPs, otherwise ruby installation is skipped
include_recipe 'rbenv::user_install'

# For each declared ruby, install it for teamcity user and install bundler
node[:teamcity][:agent][:rubies].each do |ruby|

  rbenv_ruby ruby do
    user node[:teamcity][:system][:user]
    only_if { node[:teamcity][:agent][:build_tools].include?('ruby') }
  end

  rbenv_gem 'bundler' do
    rbenv_version ruby
    user node[:teamcity][:system][:user]
    only_if { node[:teamcity][:agent][:build_tools].include?('ruby') }
  end

end

rbenv_rehash 'recreate shims for teamcity rbenv' do
  user node[:teamcity][:system][:user]
  only_if { node[:teamcity][:agent][:build_tools].include?('ruby') }
end

# Take the last (newer in default attributes) ruby as global ruby
rbenv_global node[:teamcity][:agent][:rubies].last do
  user node[:teamcity][:system][:user]
  only_if { node[:teamcity][:agent][:build_tools].include?('ruby') }
end
