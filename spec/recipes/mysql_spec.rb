require 'spec_helper'

describe 'teamcity::mysql' do

  let(:chef_run) do
    ChefSpec::Runner.new do |node|
      node.set[:mysql][:server_root_password] = 'secret'
    end.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  def create_database_user(username, action = :grant)
    ChefSpec::Matchers::ResourceMatcher.new('mysql_database_user', action, username)
  end

  def download_file(resource_name, action)
    ChefSpec::Matchers::ResourceMatcher.new('ark', action, resource_name)
  end

  it 'should include server recipe' do
    expect(chef_run).to include_recipe 'teamcity::server'
  end

  it 'should include mysql chef gem recipe' do
    expect(chef_run).to include_recipe 'mysql-chef_gem'
  end

  it 'should create teamcity database user' do
    expect(chef_run).to create_database_user('teamcity')
  end

  it 'should download mysql java connector' do
    expect(chef_run).to download_file('mysql-connector', :cherry_pick).
                            with_url('http://cdn.mysql.com/Downloads/Connector-J/mysql-connector-java-5.1.30.tar.gz')
  end

  it 'should create database configuration file' do
    expect(chef_run).to create_directory("#{node[:teamcity][:server][:data_dir]}/config")
    expect(chef_run).to render_file("#{node[:teamcity][:server][:data_dir]}/config/database.properties").
                            with_content('connectionUrl=jdbc:mysql://')
    db_config_template = chef_run.template("#{node[:teamcity][:server][:data_dir]}/config/database.properties")
    expect(db_config_template).to notify('service[teamcity-server]').to(:restart)
  end

end
