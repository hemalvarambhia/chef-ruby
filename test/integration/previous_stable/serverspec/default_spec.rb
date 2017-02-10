require 'spec_helper'

describe 'installing ruby' do
  describe command('ruby -v') do
    its(:stdout) { should match 'ruby 2.3.3' }
  end
end
