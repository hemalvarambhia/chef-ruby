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

ruby_tar_ball = "ruby-#{node[:ruby][:version]}.tar.gz"
source_code_site = "http://ftp.ruby-lang.org/pub/ruby/#{node[:ruby][:version][0..2]}/#{ruby_tar_ball}"
remote_file(ruby_tar_ball) do
  source source_code_site
  action :create
end

install_dir = node[:ruby][:installation_dir]
execute("untar-ruby-source-code") do
  command "tar -zxf #{ruby_tar_ball} -C #{install_dir}"
  action :run
end

execute("compile-ruby-#{node[:ruby][:version]}") do
  cwd "#{install_dir}/ruby-#{node[:ruby][:version]}"
  command "autoconf && ./configure && make && make install"
  action :run
end