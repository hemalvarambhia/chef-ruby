require 'serverspec'

set :backend, :exec
set :path, '/bin:/usr/local/bin:$PATH'