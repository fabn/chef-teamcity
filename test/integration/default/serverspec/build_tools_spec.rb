require 'spec_helper'

describe 'Installed build tools' do

  describe command(%q{su -l teamcity -c 'ruby -v'}) do
    it { should return_stdout /ruby 2.1.1/ }
  end

  describe command('phantomjs --version') do
    it { should return_stdout '1.9.7' }
  end

  describe command('which virtualbox') do
    it { should return_exit_status 0 }
  end

  describe command('vagrant --version') do
    it { should return_stdout 'Vagrant 1.5.2' }
  end

end
