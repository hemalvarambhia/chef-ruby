require_relative '../spec_helper'

describe 'chef-ruby::rubygems' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  context "when rubygems is not already installed" do
    it "downloads the rubygems source code" do
      expect(chef_run).to create_remote_file("rubygems-1.8.24.tgz").with(
                              source: "http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz"
                          )
    end

    it "installs rubygems" do
      expect(chef_run).to install_rubygems("1.8.24")
    end
  end

  context "when rubygems is already installed" do
    it "does not download the rubygems source" do
      Chef::Resource::RemoteFile.any_instance.stub(:rubygems_already_installed?).and_return true

      expect(chef_run).to_not create_remote_file("rubygems-1.8.24.tgz").with(
                              source: "http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz"
                          )
    end

    it "does not install rubygems" do
      Chef::Resource::Execute.any_instance.stub(:rubygems_already_installed?).and_return true

      expect(chef_run).to_not install_rubygems("1.8.24")
    end
  end
end