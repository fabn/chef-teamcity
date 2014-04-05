require 'spec_helper'

describe 'teamcity::common' do

  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  def create_user_account(user)
    ChefSpec::Matchers::ResourceMatcher.new('user_account', 'create', user)
  end

  it 'should install java' do
    expect(chef_run).to include_recipe 'java'
  end

  it 'should create a system user to run teamcity' do
    expect(chef_run).to create_user_account(node[:teamcity][:system][:user]).
                            with_home(node[:teamcity][:system][:home])
  end

end