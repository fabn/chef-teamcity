require 'spec_helper'

describe 'MySQL configuration for teamcity' do

  describe service('mysql') do
    it { should be_running }
    it { should be_enabled }
  end

  describe command(%q{mysql -u teamcity -pteamcity teamcity -e 'SHOW TABLES'}) do
    it { should return_exit_status 0 }
  end

  describe command(%q{mysql -prootpass -e 'SHOW DATABASES'}) do
    it { should return_stdout /teamcity/ }
  end

end
