require_relative '../spec_helper'

describe "chef-ruby::default" do

  describe "patching ruby" do
    context "On ubuntu servers" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "ubuntu", version: "12.04").converge(described_recipe) }

      it "is does not copy the patch on to ubuntu servers" do
        expect(chef_run).to_not create_cookbook_file("/tmp/ossl_no_ec2m.patch")
      end

      it "does not apply the patch" do
        expect(chef_run).to_not run_execute("patch -p1 < /tmp/ossl_no_ec2m.patch")
      end
    end

    context "CentOS 5.x servers" do
      let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "5.8").converge(described_recipe) }

      it "does not copy the patch on to the server" do
        expect(chef_run).to_not create_cookbook_file("/tmp/ossl_no_ec2m.patch")
      end

      it "applies the patch" do
        expect(chef_run).to_not run_execute("patch -p1 < /tmp/ossl_no_ec2m.patch")
      end
    end
  end
end