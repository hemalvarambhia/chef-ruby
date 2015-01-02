require_relative '../spec_helper'

describe "chef-ruby::autoconf" do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "downloads autoconf source code version >=2.60" do
    expect(chef_run).to create_remote_file("autoconf-2.67.tar.gz").with(
                            source: "http://ftp.gnu.org/gnu/autoconf/autoconf-2.67.tar.gz"
                        )
  end

  it "installs autoconf" do
    expect(chef_run).to run_execute("build-autoconf").with(
                            command: "./configure --prefix=/usr && make && make install",
                            cwd: "#{chef_run.node[:ruby][:src_dir]}/autoconf-2.67"
                        )
  end
end