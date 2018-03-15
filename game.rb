require './classes.rb'
require './modules.rb'

include HangMethods
#New_game or load_game
if File.zero?("save.txt")
  new_game
else
  puts "Would you like to continue from last game? Y/n"
  answer = gets.chomp
  load_game if answer[0].downcase == 'y'
  new_game if answer[0].downcase == 'n'
end
