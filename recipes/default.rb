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
end
