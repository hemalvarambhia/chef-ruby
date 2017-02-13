require 'spec_helper'
describe ChefRuby::Helper do
  let(:client_class) {
    Class.new {
      include ChefRuby::Helper

      def node
        {ruby: {version: "1.9.2-p320", bin_dir: "/usr/local/bin"} }
      end
    }
  }

  describe "checking ruby is already installed" do
    let(:shellout) { double(run_command: nil, error!: nil, stdout: '', stderr: double(empty?: true)) }

    before :each do
      Mixlib::ShellOut.stub(:new).and_return(shellout)
      allow(shellout).to receive :live_stream
    end

    it "builds the correct command" do
      expect(Mixlib::ShellOut).to receive(:new).with('[ -x /usr/local/bin/ruby ] && /usr/local/bin/ruby -v', hash_including(:returns=>[0, 2]))
      expect(shellout).to receive(:live_stream=).and_return(nil)
      client_class.new.already_installed?('1.9.2-p320')
    end

    context "when ruby is not installed" do
      let(:shellout) { double(run_command: nil, error!: nil, stdout: "", stderr: double(empty?: true)) }

      before :each do
        Mixlib::ShellOut.stub(:new).and_return(shellout)
      end

      it "confirms the required version is not installed" do
        expect(shellout).to receive(:live_stream=).and_return(nil)

        expect(client_class.new.already_installed?('1.9.2-p320')).to eq(false)
      end
    end

    context "when different version installed" do
      let(:shellout) { double(run_command: nil, error!: nil, stdout: "ruby 1.8.7 (2013-06-27 patchlevel 358) [x86_64-linux]", stderr: double(empty?: true)) }

      before :each do
        Mixlib::ShellOut.stub(:new).and_return(shellout)
      end

      it "confirms the required version is not installed" do
        expect(shellout).to receive(:live_stream=).and_return(nil)

        expect(client_class.new.already_installed?('1.9.2-p320')).to eq(false)
      end
    end

    context "when same version of ruby is installed" do
      context "when patch level is different" do
        let(:shellout) { double(run_command: nil, error!: nil, stdout: 'ruby 1.9.2p321 (2012-04-20 revision 35421) [x86_64-linux]', stderr: double(empty?: true)) }

        before :each do
          Mixlib::ShellOut.stub(:new).and_return(shellout)
        end

        it "confirms the required version is not installed" do
          expect(shellout).to receive(:live_stream=).and_return(nil)

          expect(client_class.new.already_installed?('1.9.2-p320')).to eq(false)
        end
      end

      context "when the patch level is the same" do
        let(:shellout) { double(run_command: nil, error!: nil, stdout: 'ruby 1.9.2p320 (2012-04-20 revision 35421) [x86_64-linux]', stderr: double(empty?: true)) }

        before :each do
          Mixlib::ShellOut.stub(:new).and_return(shellout)
        end

        it "confirms the required version is not installed" do
          expect(shellout).to receive(:live_stream=).and_return(nil)

          expect(client_class.new.already_installed?('1.9.2-p320')).to eq(true)
        end
      end
    end

    context "ruby 1.8 series" do
      let(:client_class) {
        Class.new {
          include ChefRuby::Helper

          def node
            {ruby: {version: "1.8.7-p358", bin_dir: "/usr/local/bin"}}
          end
        }
      }
      let(:shellout) { double(run_command: nil, error!: nil, stdout: "ruby 1.8.7 (2013-06-27 patchlevel 358) [x86_64-linux]", stderr: double(empty?: true)) }

      before :each do
        Mixlib::ShellOut.stub(:new).and_return(shellout)
      end

      it "confirms ruby-1.8.x is installed" do
        expect(shellout).to receive(:live_stream=).and_return(nil)

        expect(client_class.new.already_installed?('1.8.7-p358')).to eq(true)
      end
    end
  end

end