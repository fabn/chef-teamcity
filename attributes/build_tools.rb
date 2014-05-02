# Build tools attributes

# List of installed tools used by agent to run builds
default[:teamcity][:agent][:build_tools] = %w(ruby phantomjs virtualbox vagrant)

# Used to install additional packages used in various builds
default[:teamcity][:agent][:build_packages] = []

# Ensure default attributes are required
include_attribute 'teamcity::default'

# Ruby versions to install into CI server, currently with rbenv
default[:teamcity][:agent][:rubies] = %w(1.9.3-p545 2.0.0-p451 2.1.1)
# Use this to specify the interpreter to set as default ruby
default[:teamcity][:agent][:global_ruby] = nil

# Maven it's not installed because it's bundled into teamcity

# Used to install phantomjs in the machine, uses latest release available at this moment
default[:teamcity][:agent][:phantomjs][:archive] = node[:kernel][:machine] == 'x86_64' ? 'phantomjs-1.9.7-linux-x86_64.tar.bz2' : 'phantomjs-1.9.7-linux-i686.tar.bz2'
default[:teamcity][:agent][:phantomjs][:remote_file] = "https://bitbucket.org/ariya/phantomjs/downloads/#{node[:teamcity][:agent][:phantomjs][:archive]}"
default[:teamcity][:agent][:phantomjs][:checksum] = node[:kernel][:machine] == 'x86_64' ? '473b19f7eacc922bc1de21b71d907f182251dd4784cb982b9028899e91dcb01a' : '2a49bb20ee4b71b8ac1837857a4dddd52f3217d1356afe58e17c5a4e4829cdb9'

# Used to install vagrant in the remote machine
default[:teamcity][:agent][:vagrant][:package] = node[:kernel][:machine] == 'x86_64' ? 'vagrant_1.5.2_x86_64.deb' : 'vagrant_1.5.2_i686.deb'
default[:teamcity][:agent][:vagrant][:remote_file] = "https://dl.bintray.com/mitchellh/vagrant/#{node[:teamcity][:agent][:vagrant][:package]}"
default[:teamcity][:agent][:vagrant][:checksum] = node[:kernel][:machine] == 'x86_64' ? '8d90e7528d86fb58a3341639dcbf28a576dcf232881fefa02c5704593916ec76' : '2444c4e49fd397a98c4f1e8fcc540d26d8a8c766c9df4ea9c089042ad7a650c7'
