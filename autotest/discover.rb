Autotest.add_hook :initialize do |at|
  at.clear_mappings
  at.add_mapping(%r%^lib/(.*)\.rb$%) { |_, m|
    ["spec/#{m[1]}_spec.rb"]
  }
  at.add_mapping(%r%^spec/(.*)\.rb$%) { |_, m|
    ["spec/#{m[1]}.rb"]
  }
end

class Autotest::MiniSpec < Autotest
end
