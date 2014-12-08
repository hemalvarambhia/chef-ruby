require_relative '../spec_helper'

describe 'ruby::default' do
  context "on ubuntu" do
    let(:chef_run) { ChefSpec::Runner.new.converge(described_recipe) }

    it "does nothing" do

    end
  end
end
