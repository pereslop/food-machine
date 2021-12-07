require 'byebug'
current_path = File.dirname(__FILE__)

require  "./#{current_path}/lib/machine.rb"
require  "./#{current_path}/lib/product.rb"

require 'byebug'

ON_STATUS = 'yes'

puts 'turn on the mathine(yes)'
status = gets.chomp.downcase == ON_STATUS

if status
  puts 'please input money'
  puts "you can input only next money: #{Machine::ALLOWED_MONEY.keys.join(', ')}"
  puts 'please puts money:'
  Machine.start
  Machine.input_money
else
  puts 'machine is turned off'
end
