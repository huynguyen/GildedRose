def run_spec(file)
  unless File.exist?(file)
    puts "#{file} does not exist"
    return
  end
  puts "Running #{file}"
  system "rspec #{file}"
  puts
end

watch("(.*)\.rb") do |m|
  if a = m.to_s.match(/_spec/)
    run_spec m[0]
  else 
    run_spec %{#{m[1]}_spec.rb}
  end
end
