if defined?(ChefSpec)
  def install_ruby(version)
    run_execute("compile-ruby-#{version}").with(command: "autoconf && ./configure && make && make install")
  end

  def install_rubygems(version)
    run_execute("compile-rubygems-#{version}").with(command: "/usr/local/src/bin/ruby setup.rb")
  end
end