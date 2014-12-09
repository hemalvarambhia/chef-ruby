#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

node[:ruby][:dependencies].each { |dependency|
  package dependency do
    action :install
  end
}