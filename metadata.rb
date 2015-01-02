name             'chef-ruby'
maintainer       'Software Craftsman of London'
maintainer_email 'hemal@softwarecraftsman.co.uk'
license          'All rights reserved'
description      'Installs ruby from source'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'
depends "apt"
depends "build-essential"
depends "yum-epel"