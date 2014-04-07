require 'spec_helper'

describe 'teamcity::agent' do

  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  before do
    stub_command('test -d /opt/teamcity/agent').and_return(false)
  end

  def download_file(resource_name, action)
    ChefSpec::Matchers::ResourceMatcher.new('ark', action, resource_name)
  end

  it 'should execute common recipe' do
    expect(chef_run).to include_recipe 'teamcity::common'
  end

  context 'when install_method is server' do

    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set[:teamcity][:agent][:install_method] = 'server'
      end.converge(described_recipe)
    end

    it 'should download agent distribution from server' do
      expect(chef_run).to download_file('agent', :put).
                              with_url(node[:teamcity][:agent][:agent_archive_url])
    end

  end

  context 'when install_method is source' do

    it 'should include server recipe' do
      expect(chef_run).to include_recipe 'teamcity::server'
    end

    it 'should copy agent distribution from server sources' do
      expect(chef_run).to run_execute("cp -a #{node[:teamcity][:server][:path]}/buildAgent #{node[:teamcity][:agent][:path]}")
    end

  end

  it 'should create conf directory' do
    expect(chef_run).to create_directory("#{node[:teamcity][:agent][:path]}/conf")
  end

  it 'should configure agent with properties file' do
    expect(chef_run).to render_file("#{node[:teamcity][:agent][:path]}/conf/buildAgent.properties").
                            with_content(%Q{serverUrl=#{node[:teamcity][:agent][:server_url]}})
  end

  it 'should create an init script' do
    startup_line = "DAEMON=#{node[:teamcity][:agent][:path]}/bin/agent.sh"
    expect(chef_run).to render_file('/etc/init.d/teamcity-agent').with_content(startup_line)
  end

  it 'should enable and start the service' do
    expect(chef_run).to start_service('teamcity-agent')
    expect(chef_run).to enable_service('teamcity-agent')
  end

end
