require 'spec_helper'

describe 'installing rubygems' do
  describe command('gem -v') do
    its(:stdout) { should match '2.6.10' }
  end
end