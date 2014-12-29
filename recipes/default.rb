#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
case node.platform_family
  when "debian"
    include_recipe "apt::default"
    include_recipe "build-essential::default"
    node[:ruby][:dependencies].each { |dependency|
      package dependency do
        action :install
      end
    }
  when "rhel"
    include_recipe "yum-epel::default"
    ["readline", "readline-devel", "zlib", "zlib-devel", "libyaml-devel", "libffi-devel", "bzip2", "libtool",
     "openssl", "openssl-devel", "libxml2", "libxml2-devel", "libxslt", "libxslt-devel"].each { |dependency|
      package dependency do
        action :install
      end
    }
end
