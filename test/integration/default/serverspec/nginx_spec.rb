require 'spec_helper'

describe 'Nginx proxy for teamcity' do

  describe service('nginx') do
    it { should be_running }
    it { should be_enabled }
  end

  describe file('/etc/nginx/sites-enabled/build.vagrantup.com') do
    it { should contain('proxy_pass http://127.0.0.1:8111/;') }
    it { should be_linked_to '/etc/nginx/sites-available/build.vagrantup.com' }
  end

end
