require 'serverspec'

set :backend, :exec

describe "installing ruby" do
  describe command("/usr/local/bin/ruby -v") do
    its(:stdout) {
      should match "ruby 1.9.2p320"
    }
  end
end