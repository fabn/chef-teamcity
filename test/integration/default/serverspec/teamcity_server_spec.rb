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

  describe 'server paths' do

    describe file('/opt/teamcity/server') do
      it { should be_linked_to '/opt/teamcity/server-8.1.1/' }
    end

    describe file('/opt/teamcity/server-8.1.1/') do
      it { should be_directory }
      it { should be_owned_by('teamcity') }
      it { should be_grouped_into('teamcity') }
    end

  end

end