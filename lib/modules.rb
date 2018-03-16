module HangMethods
  #play new game with new random word
  def new_game
    answer = get_random_word
    veiled_answer = get_veiled_word(answer)
    current_try = 0
    total_tries = answer.length * 2

    new_game = Game.new(answer, veiled_answer, current_try, total_tries, false)
    request_save = new_game.play

    if request_save
      save_file request_save
    end
  end
  #load info from save.txt and play game
  def load_game
    data = File.read("save.txt")
    load_game = Game.from_json data
    request_save = load_game.play

    if request_save
      save_file request_save
    end
  end
  #save info on save.txt file
  def save_file info
    save_game = Game.new(info[0], info[1], info[2], info[3], info[4])
    File.open("save.txt", "w") do |file|
      file.puts save_game.to_json
    end
  end
  #getting random word from 5desk.txt that is between 5 to 13 characters
  def get_random_word
    word = File.read("dic/5desk.txt").split.find_all { |word| word.length > 4 && word.length < 13 }
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
      return input
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
  #helper method used: #get_unveiled, #show_unveiled, #right_guess, #game_over
  def play_loop (total, current, word, veiled_word, save)
    while (total - current != 0) do
      show_unveiled (veiled_word)
      guess = player_input
      #checking guess and reacting to guess
      if guess == 'save'
        return [word, veiled_word, current, total, false]
        break
      elsif right_guess(word, veiled_word, guess)
        veiled_word = get_unveiled(word, veiled_word, guess)
        break if game_over(total, current, word, veiled_word, guess)
      else
        #try is spent
        current += 1
        break if game_over(total, current, word, veiled_word, guess)
      end
    end
  end
  #main method for checking if game is over and announcing result: used in #play_loop
  def game_over (total, current, word, veiled_word, guess)
    if check_lost(total, current)
      puts "You Lost!"
      puts "The word was: #{word}"
      File.open("save.txt", "w") {}
      return true
    elsif check_win(word, veiled_word)
      puts "Answer is: #{word}"
      puts "You Won!"
      File.open("save.txt", "w") {}
      return true
    else
      puts "You tried #{guess[0]}. It's wrong! Try again."
      puts "You have #{total - current} tries left."
    end
  end

  def right_guess (word, veiled_word, guess)
    return true if word.downcase.include? guess
  end
  #below methods used in #gave_over
  def check_win (word, veiled_word)
    return true if word == veiled_word.join
  end

  def check_lost (total, current)
    return true if total - current == 0
  end
end
