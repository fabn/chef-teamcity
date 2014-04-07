require 'spec_helper'

describe 'teamcity::nginx' do

  matcher :enable_nginx_site do |site|
    match do |chef_run|
      chef_run.resource_collection.any? do |resource|
        resource.resource_name == :execute && resource.name =~ /.*nxensite.*#{site}/
      end
    end
  end

  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  it 'should install nginx' do
    expect(chef_run).to include_recipe 'nginx'
  end

  it 'should configure virtual host' do
    expect(chef_run).to render_file("#{node['nginx']['dir']}/sites-available/#{node[:teamcity][:server][:server_name]}").
                            with_content("server_name #{node[:teamcity][:server][:server_name]}")
  end

  it 'should enable virtual host' do
    expect(chef_run).to enable_nginx_site(node[:teamcity][:server][:server_name])
  end

end
