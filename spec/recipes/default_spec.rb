require_relative '../spec_helper'

describe 'chef-ruby::default' do
  describe "installing the latest stable release" do
    let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

    before :each do
      Chef::Resource::RemoteFile.any_instance.stub(:already_installed?).and_return(false)
      Chef::Resource::Execute.any_instance.stub(:already_installed?).and_return(false)
      Chef::Resource::RemoteFile.any_instance.stub(:autoconf_already_installed?).and_return(true)
      Chef::Resource::Execute.any_instance.stub(:autoconf_already_installed?).and_return(true)
    end

    it "downloads the ruby source code" do
      expect(chef_run).to create_remote_file("ruby-2.2.1.tar.gz").with(
                              source: "http://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.1.tar.gz"
                          )
    end

    context "on ubuntu" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "12.04").converge(described_recipe) }

      it "updates apt repo" do
        expect(chef_run).to run_execute 'apt-get update'
      end

      it "installs packages for compiling C code" do
        %w{autoconf binutils-doc bison build-essential flex gettext ncurses-dev}.each do |pkg|
          expect(chef_run).to install_package pkg
        end
      end

      it "installs dependencies" do
        [
            "openssl", "libreadline6", "libreadline6-dev",
            "zlib1g", "zlib1g-dev", "libssl-dev",
            "libyaml-dev", "libxml2-dev", "libxslt-dev",
            "libc6-dev", "ncurses-dev", "libtool", "libffi-dev"
        ].each { |dependency|
          expect(chef_run).to install_package dependency
        }
      end
    end

    context "on CentOS" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "6.4").converge(described_recipe) }

      it "updates the yum repos" do
        expect(chef_run).to run_execute 'yum -y update'
      end

      it 'installs packages for compiling C code' do
        %w{autoconf bison flex gcc gcc-c++ kernel-devel make m4 patch}.each do |pkg|
          expect(chef_run).to install_package pkg
        end
      end

      it "installs dependencies" do
        ["readline", "readline-devel", "zlib", "zlib-devel", "libyaml-devel", "libffi-devel", "bzip2", "libtool",
         "openssl", "openssl-devel", "libxml2", "libxml2-devel", "libxslt", "libxslt-devel"].each { |dependency|
          expect(chef_run).to install_package dependency
        }
      end
    end

    it "installs the latest autoconf" do
      expect(chef_run).to include_recipe "chef-ruby::autoconf"
    end

    it "installs ruby 2.2.1" do
      expect(chef_run).to install_ruby "2.2.1"
    end

    describe "installing ruby without the patch" do
      let(:chef_run) { ChefSpec::SoloRunner.new do |node|
        node.set[:ruby][:version] = "2.1.2"
      end.converge(described_recipe) }

      it "installs ruby 2.1.2" do
        expect(chef_run).to install_ruby "2.1.2"
      end
    end

    describe "when ruby version is already installed" do
      it "does not download the source code" do
        Chef::Resource::RemoteFile.any_instance.stub(:already_installed?).and_return(true)

        expect(chef_run).to_not create_remote_file("ruby-2.2.1.tar.gz").with(
                                    source: "http://ftp.ruby-lang.org/pub/ruby/2.2/ruby-2.2.1.tar.gz"
                                )
      end

      it "does not install ruby" do
        Chef::Resource::Execute.any_instance.stub(:already_installed?).and_return(true)

        expect(chef_run).to_not install_ruby "2.2.1"
      end
    end

  end
end
