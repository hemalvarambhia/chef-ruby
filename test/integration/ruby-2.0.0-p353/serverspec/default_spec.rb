require 'spec_helper'

describe "installing ruby" do
  describe command("ruby -v") do
    its(:stdout) {
      should match "ruby 2.0.0p353"
    }
  end
end