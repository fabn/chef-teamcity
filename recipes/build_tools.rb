#
# Cookbook Name:: teamcity
# Recipe:: build_tools
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

# include common recipe
include_recipe 'teamcity::common'

# Install ruby


# Install phantomjs
ark 'phantomjs' do
  url node[:teamcity][:agent][:phantomjs][:remote_file]
  checksum node[:teamcity][:agent][:phantomjs][:checksum]
  path '/opt'
  action :put
  only_if { node[:teamcity][:agent][:build_tools].include?('phantomjs') }
end

link '/usr/bin/phantomjs' do
  to '/opt/phantomjs/bin/phantomjs'
  only_if { node[:teamcity][:agent][:build_tools].include?('phantomjs') }
end

# Install virtualbox and vagrant
