require 'serverspec'

set :backend, :exec
set :path, '/bin:/usr/local/bin:$PATH'

describe "installing rubygems" do
  describe command("gem -v") do
    its(:stdout) {
      should match "1.8.24"
    }
  end
end