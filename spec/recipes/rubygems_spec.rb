require_relative '../spec_helper'

describe 'chef-ruby::rubygems' do
  let(:chef_run) { ChefSpec::SoloRunner.new.converge(described_recipe) }

  it "downloads the rubygems source code" do
    expect(chef_run).to create_remote_file("rubygems-1.8.24.tgz").with(
                            source: "http://production.cf.rubygems.org/rubygems/rubygems-1.8.24.tgz"
                        )
  end

  it "installs rubygems" do
    expect(chef_run).to install_rubygems("1.8.24")
  end
end