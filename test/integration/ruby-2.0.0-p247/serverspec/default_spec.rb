require 'serverspec'

set :backend, :exec
set :path, '/bin:/usr/local/bin:$PATH'

describe "installing ruby" do
  describe command("ruby -v") do
    its(:stdout) {
      should match "ruby 2.0.0p247"
    }
  end
end