require 'spec_helper'

describe 'installing ruby' do
  describe command('ruby -v') do
    its(:stdout) { should match 'ruby 2.2.6' }
  end
end
