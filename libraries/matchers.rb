if defined?(ChefSpec)
  def install_ruby(version)
    run_execute("compile-ruby-#{version}").with(command: "autoconf && ./configure && make && make install")
  end
end