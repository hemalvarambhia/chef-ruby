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

      it "does not apply the patch" do
        expect(chef_run).to_not run_execute("patch -p1 < /tmp/ossl_no_ec2m.patch")
      end
    end

    context "CentOS 6.x servers" do
      context "Ruby versions less than 2" do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "6.0").converge(described_recipe) }

        it "copies the patch on to the server" do
          expect(chef_run).to create_cookbook_file("/tmp/ossl_no_ec2m.patch").with(source: "ossl_no_ec2m.patch")
        end

        it "applies the patch" do
          path_to_ruby_src = "#{chef_run.node[:ruby][:src_dir]}/ruby-#{chef_run.node[:ruby][:version]}"
          expect(chef_run).to run_execute("patch -p1 < /tmp/ossl_no_ec2m.patch").with(cwd: path_to_ruby_src)
        end
      end

      context "Ruby version 2.0.0-p247" do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "6.0") do |node|
          node.set[:ruby][:version] = "2.0.0-p247"
        end.converge(described_recipe) }

        it "copies the patch on to the server" do
          expect(chef_run).to create_cookbook_file("/tmp/ossl_no_ec2m.patch").with(source: "ossl_no_ec2m.patch")
        end

        it "applies the patch" do
          path_to_ruby_src = "#{chef_run.node[:ruby][:src_dir]}/ruby-#{chef_run.node[:ruby][:version]}"
          expect(chef_run).to run_execute("patch -p1 < /tmp/ossl_no_ec2m.patch").with(cwd: path_to_ruby_src)
        end
      end

      context "Ruby version > 2.0.0-p247" do
        let(:chef_run) { ChefSpec::SoloRunner.new(platform: "centos", version: "6.0") do |node|
          node.set[:ruby][:version] = "2.0.0-p598"
        end.converge(described_recipe) }

        it "does not copy the patch on to the server" do
          expect(chef_run).to_not create_cookbook_file("/tmp/ossl_no_ec2m.patch").with(source: "ossl_no_ec2m.patch")
        end

        it "does not apply the patch" do
          path_to_ruby_src = "#{chef_run.node[:ruby][:src_dir]}/ruby-#{chef_run.node[:ruby][:version]}"
          expect(chef_run).to_not run_execute("patch -p1 < /tmp/ossl_no_ec2m.patch").with(cwd: path_to_ruby_src)
        end
      end
    end
  end
end