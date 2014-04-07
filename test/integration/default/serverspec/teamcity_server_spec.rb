require 'spec_helper'

describe 'Teamcity standalone installation' do

  describe user('teamcity') do
    it { should exist }
    it { should have_home_directory('/opt/teamcity') }
  end

  describe service('teamcity-server') do
    it { should be_running }
    it { should be_enabled }
  end

end