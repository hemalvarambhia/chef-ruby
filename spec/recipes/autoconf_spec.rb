require_relative '../spec_helper'

describe "chef-ruby::autoconf" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }
  context "when autoconf is not already installed" do
    before :each do
      Chef::Resource::RemoteFile.any_instance.stub(:autoconf_already_installed?).and_return(false)
      Chef::Resource::Execute.any_instance.stub(:autoconf_already_installed?).and_return(false)
    end

    it "downloads the latest autoconf source code version >=2.60" do
      expect(chef_run).to create_remote_file("autoconf-2.69.tar.gz").with(
                              source: "http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz"
                          )
    end

    it "installs autoconf" do
      expect(chef_run).to run_execute("build-autoconf").with(
                              command: "./configure --prefix=/usr && make && make install",
                              cwd: "#{chef_run.node[:ruby][:src_dir]}/autoconf-2.69"
                          )
    end
  end

  context "when autoconf is installed" do
    before :each do
      Chef::Resource::RemoteFile.any_instance.stub(:autoconf_already_installed?).and_return(true)
      Chef::Resource::Execute.any_instance.stub(:autoconf_already_installed?).and_return(true)
    end

    it "downloads the latest autoconf source code version >=2.60" do
      expect(chef_run).to_not create_remote_file("autoconf-2.69.tar.gz")
    end

    it "installs autoconf" do
      expect(chef_run).to_not run_execute("build-autoconf")
    end
  end
end