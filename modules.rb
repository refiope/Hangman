module HangMethods
  #getting random word from 5desk.txt that is between 5 to 13 characters
  def get_random_word
    word = File.read("5desk.txt").split.find_all { |word| word.length > 4 && word.length < 13 }
    return word.sample(1).join
  end

  #getting '_'s based on the length of the random word
  def get_veiled_word word
    veiled_word = []
    word.length.times do
      veiled_word.push("_")
    end
    return veiled_word
  end

  #getting guess from player
  def player_input
    input = gets.chomp.downcase
    if input == ''
      puts "Choose a letter between A-Z"
      player_input
    elsif input[0] =~ /[^a-z]/
      puts "Choose a letter between A-Z"
      player_input
    else
      return input[0]
    end
  end

  #helper_method used in #play_loop: reveals the right character assuming guess is right
  def get_unveiled (word, veiled_word, guess)
    right_guess_index = []
    word.split('').each_with_index do |letter, index|
      right_guess_index.push(index) if letter.downcase == guess
    end
    right_guess_index.each { |index| veiled_word[index] = word[index] }
    return veiled_word
  end

  #helper_method used in #play_loop: displays the updated veiled_word
  def show_unveiled veiled_word
    print "\n\n"
    veiled_word.each do |letter|
      print " #{letter} "
    end
    print "\n\n"
  end

  #main loop for playing the game: a lot of helper_methods are used.
  #helper method used: #get_unveiled, #show_unveiled, #right_guess, #check_win || lost
  def play_loop (total, current, word, veiled_word, player)
    while (total - current != 0) do
      show_unveiled (veiled_word)
      guess = player.get_input

      if right_guess(word, veiled_word, guess)
        veiled_word = get_unveiled(word, veiled_word, guess)
      else
        current += 1 #<= this increment prevented me from making this function shorter
        if check_lost(total, current)
          puts "You Lost!"
          puts "The word was: #{word}"
          break
        else
          puts "You tried #{guess}. It's wrong! Try again."
          puts "You have #{total - current} tries left."
        end
      end

      if check_win(word, veiled_word)
        puts "You Won!"
        break
      end
    end
  end

  #helper_methods below used in #play_loop
  def right_guess (word, veiled_word, guess)
    return true if word.include? guess
  end

  def check_win (word, veiled_word)
    return true if word == veiled_word.join
  end

  def check_lost (total, current)
    return true if total - current == 0
  end
end
