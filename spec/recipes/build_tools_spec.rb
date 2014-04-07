require 'spec_helper'

describe 'teamcity::build_tools' do

  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  def download_file(resource_name, action = :put)
    ChefSpec::Matchers::ResourceMatcher.new('ark', action, resource_name)
  end

  it 'should include common recipe' do
    expect(chef_run).to include_recipe 'teamcity::common'
  end

  it 'should download phantomjs and link it into bin' do
    expect(chef_run).to download_file('phantomjs').with_url(node[:teamcity][:agent][:phantomjs][:remote_file])
    expect(chef_run).to create_link('/usr/bin/phantomjs').with(to: '/opt/phantomjs/bin/phantomjs')
  end

  it 'should install virtualbox package' do
    expect(chef_run).to install_package('virtualbox')
  end

end