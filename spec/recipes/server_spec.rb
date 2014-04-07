require 'spec_helper'

describe 'teamcity::server' do

  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  it 'should execute common recipe' do
    expect(chef_run).to include_recipe 'teamcity::common'
  end

  it 'should configure bundled tomcat' do
    expect(chef_run).to render_file("#{node[:teamcity][:server][:path]}/conf/server.xml").
                            with_content(%Q{address="#{node[:teamcity][:server][:listen_address]}"}).
                            with_content(%Q{port="#{node[:teamcity][:server][:port]}"})
  end

  it 'should add server startup variables' do
    expect(chef_run).to render_file("#{node[:teamcity][:server][:path]}/bin/teamcity-init.sh").
                            with_content('TEAMCITY_SERVER_MEM_OPTS')
  end

  it 'should create data directory' do
    expect(chef_run).to create_directory(node[:teamcity][:server][:data_dir]).
                            with_owner(node[:teamcity][:system][:user]).
                            with_group(node[:teamcity][:system][:group])
  end

  it 'should create an init script' do
    startup_line = "DAEMON=#{node[:teamcity][:server][:path]}/bin/teamcity-server.sh"
    expect(chef_run).to render_file('/etc/init.d/teamcity-server').with_content(startup_line)
  end

  it 'should enable and start the service' do
    expect(chef_run).to start_service('teamcity-server')
    expect(chef_run).to enable_service('teamcity-server')
  end

end
