require 'spec_helper'

describe 'teamcity::build_tools' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:teamcity][:agent][:build_packages] = %w(libcurl4-openssl-dev libpq-dev libsqlite3-dev)
    end.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  def download_file(resource_name, action = :put)
    ChefSpec::Matchers::ResourceMatcher.new('ark', action, resource_name)
  end

  before do
    stub_command('which vagrant').and_return(false)
    stub_command('git --version >/dev/null').and_return(false)
    stub_command('test -d /opt/teamcity/agent').and_return(false)
  end

  it 'should include common recipe' do
    expect(chef_run).to include_recipe 'teamcity::common'
  end

  it 'should include rbenv default recipe' do
    expect(chef_run).to include_recipe 'teamcity::ruby'
  end

  it 'should download phantomjs and link it into bin' do
    expect(chef_run).to download_file('phantomjs').with_url(node[:teamcity][:agent][:phantomjs][:remote_file])
    expect(chef_run).to create_link('/usr/bin/phantomjs').with(to: '/opt/phantomjs/bin/phantomjs')
  end

  it 'should install virtualbox package' do
    expect(chef_run).to install_package('virtualbox')
  end

  it 'should download and install vagrant package for the given architecture' do
    deb_package = "/tmp/#{File.basename(node[:teamcity][:agent][:vagrant][:remote_file])}"
    expect(chef_run).to create_remote_file(deb_package)
    expect(chef_run).to install_dpkg_package(deb_package)
  end

  it 'should install additional packages provided in attributes' do
    node[:teamcity][:agent][:build_packages].each do |pkg|
      expect(chef_run).to install_package(pkg)
    end
  end

end