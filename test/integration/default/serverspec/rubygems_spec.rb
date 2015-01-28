require 'spec_helper'

describe "installing rubygems" do
  describe command("gem -v") do
    its(:stdout) {
      should match "1.8.24"
    }
  end
end