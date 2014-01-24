class Log
  def self.test_output_theoretically_did(interface)
    puts "Theoretically did: #{interface.command} recipe #{interface.name}; with ingredients #{interface.options[:ingredients]}; with directions #{interface.options[:directions]}; time #{interface.options[:time]}; meal #{interface.options[:meal]}; serves #{interface.options[:serves]}; calories #{interface.options[:calories]}." if interface.options[:test_output]
  end
end