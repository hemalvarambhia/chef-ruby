#
# Cookbook Name:: ruby
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
Chef::Resource::RemoteFile.send(:include, ChefRuby::Helper)
Chef::Resource::Execute.send(:include, ChefRuby::Helper)

case node.platform_family
  when "debian"
    include_recipe "apt::default"

  when "rhel"
    include_recipe "yum-epel::default"
end

include_recipe "build-essential::default"
include_recipe "chef-ruby::autoconf"

node[:ruby][:dependencies].each { |dependency|
  package dependency do
    action :install
  end
}

ruby_tar_ball = "ruby-#{node[:ruby][:version]}.tar.gz"
source_code_site = "http://ftp.ruby-lang.org/pub/ruby/#{node[:ruby][:version][0..2]}/#{ruby_tar_ball}"
remote_file(ruby_tar_ball) do
  source source_code_site
  not_if already_installed?
  action :create
end

execute("untar-ruby-source-code") do
  command "tar -zxf #{ruby_tar_ball} -C #{node[:ruby][:src_dir]}"
  not_if already_installed?
  action :run
end

if platform?("centos") and node.platform_version.to_f >= 6.0
  cookbook_file "/tmp/ossl_no_ec2m.patch" do
    source ""
    action :create
  end
end

execute("compile-ruby-#{node[:ruby][:version]}") do
  cwd "#{node[:ruby][:src_dir]}/ruby-#{node[:ruby][:version]}"
  command "autoconf && ./configure && make && make install"
  not_if already_installed?
  action :run
end

file ruby_tar_ball do
  action :delete
end