require 'spec_helper'

describe 'uninstalling ruby' do
  describe command('ruby -v') do
    its(:stdout) { should_not match 'ruby 2.3.3' }
  end

  describe file('/usr/local/src/ruby-2.3.3') do
    it { should_not exist }
  end
end
