require 'spec_helper'

describe 'teamcity::ruby' do

  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  before do
    stub_command('test -d /opt/teamcity/agent').and_return(false)
  end

  it 'should include rbenv recipes' do
    expect(chef_run).to include_recipe 'teamcity::common'
    expect(chef_run).to include_recipe 'rbenv::default'
    expect(chef_run).to include_recipe 'rbenv::ruby_build'
  end

  it 'should install requested rubies' do
    node[:teamcity][:agent][:rubies].each do |ruby|
      expect(chef_run).to install_rbenv_ruby(ruby)
    end
  end

  context 'with global interpreter specified' do

    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set[:teamcity][:agent][:rubies] = %w(1.9.3-p545 2.0.0-p451 2.1.1)
        node.set[:teamcity][:agent][:global_ruby] = global_ruby
      end.converge(described_recipe)
    end

    let(:global_ruby) { '1.9.3-p545' }


    it 'should configure requested ruby as global' do
      expect(chef_run).to install_rbenv_ruby(global_ruby).with_global(true)
      expect(chef_run).to install_rbenv_ruby('2.0.0-p451').with_global(false)
    end

  end

  context 'without global interpreter specified' do

    let(:chef_run) do
      ChefSpec::Runner.new do |node|
        node.set[:teamcity][:agent][:rubies] = %w(1.9.3-p545 2.0.0-p451 2.1.1)
        node.set[:teamcity][:agent][:global_ruby] = nil
      end.converge(described_recipe)
    end

    it 'should choose the newest as global' do
      expect(chef_run).to install_rbenv_ruby('2.1.1').with_global(true)
      expect(chef_run).to install_rbenv_ruby('2.0.0-p451').with_global(false)
    end

  end

end
