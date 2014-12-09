require_relative '../spec_helper'

describe 'ruby::default' do
  context "on ubuntu" do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it "installs dependencies" do
      [
          "openssl", "libreadline6", "libreadline6-dev",
          "zlib1g", "zlib1g-dev", "libssl-dev",
          "libyaml-dev", "libxml2-dev", "libxslt-dev",
          "libc6-dev", "ncurses-dev", "libtool"
      ].each { |dependency|
        expect(chef_run).to install_package dependency
      }
    end
  end
end
