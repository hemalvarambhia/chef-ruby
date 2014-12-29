#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
include_recipe "build-essential::default"

case node.platform_family
  when "debian"
    include_recipe "apt::default"

  when "rhel"
    include_recipe "yum-epel::default"

end

node[:ruby][:dependencies].each { |dependency|
  package dependency do
    action :install
  end
}
