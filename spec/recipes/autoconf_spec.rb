require_relative '../spec_helper'

describe "chef-ruby::autoconf" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "downloads the autoconf source code" do
    expect(chef_run).to create_remote_file("autoconf-2.69.tar.gz").
                            with(source: "http://ftp.gnu.org/gnu/autoconf/autoconf-2.69.tar.gz")
  end
end