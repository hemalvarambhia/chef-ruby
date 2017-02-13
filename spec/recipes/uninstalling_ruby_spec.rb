require_relative '../spec_helper'

describe 'chef-ruby::uninstall' do
  let(:chef_run) { ChefSpec::SoloRunner.converge(described_recipe) }

  before :each do
    Chef::Resource::Execute.
        any_instance.stub(:already_installed?).with('2.3.3').and_return(true)
  end

  context 'given the version of ruby was previously installed' do
    it 'uninstalls ruby' do
      expect(chef_run).to(
          run_execute('uninstall-ruby-2.3.3').
              with(command: 'sudo make uninstall',
                   cwd: '/usr/local/src/ruby-2.3.3'
              ))
    end

    it 'deletes the source code' do
      expect(chef_run).to delete_directory('/usr/local/src/ruby-2.3.3')
    end
  end
end