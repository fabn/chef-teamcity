require 'spec_helper'

describe 'teamcity::default' do

  let(:chef_run) do
    ChefSpec::Runner.new.converge(described_recipe)
  end

  let(:node) { chef_run.node }

  before do
    stub_command('test -d /opt/teamcity/agent').and_return(false)
    stub_command('which vagrant').and_return(false)
  end

  it 'should include all other recipes' do
    expect(chef_run).to include_recipe'teamcity::server'
    expect(chef_run).to include_recipe'teamcity::mysql'
    expect(chef_run).to include_recipe'teamcity::agent'
    expect(chef_run).to include_recipe'teamcity::nginx'
    expect(chef_run).to include_recipe'teamcity::build_tools'
  end

end
