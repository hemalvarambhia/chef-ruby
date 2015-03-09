require 'spec_helper'

describe "installing ruby" do
  describe command("ruby -v") do
    its(:stdout) {
      should match "ruby 1.9.3p551"
    }
  end
end