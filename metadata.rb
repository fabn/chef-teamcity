name             'teamcity'
maintainer       'Fabio Napoleoni'
maintainer_email 'f.napoleoni@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures teamcity'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

depends 'java', '~> 1.22'
depends 'user'
depends 'ark'
depends 'database'
depends 'nginx', '~> 2.2.0'
