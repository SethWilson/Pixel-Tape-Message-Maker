require 'yaml'

@pixel_tape_data = YAML::load(File.open('app_config.yml'))
@label_text = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789\(\)\*\^\%\$\#\@\!\~\{\}\|\<\>\,\.\;\:'"

puts @pixel_tape_data[:available_sizes]

if @pixel_tape_data[:available_sizes].include?("300")
  puts "Yep"
else
  puts "225"
end


@label_text.split(//).each do |char|
  
  #puts "#{char} => #{@pixel_tape_data[:char_data][char][:x]}"
  
  
end

# ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789


