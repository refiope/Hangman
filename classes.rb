require './modules.rb'
include HangMethods

#class that creates random word and veiled word
class Word
  def create_word
    get_random_word
  end

  def create_veiled_word (word)
    get_veiled_word(word)
  end
end

#class that gets input
class Player
  def get_input
    player_input
  end
end

#class that uses Player and Word
class Game
  def initialize
    @player = Player.new()
    @word_class = Word.new()
    @word = @word_class.create_word
    @veiled_word = @word_class.create_veiled_word(@word)
    @current_try = 0
    @total_tries = @word.length * 2
  end

  def play
    play_loop(@total_tries, @current_try, @word, @veiled_word, @player)
  end

  def save_game
  end

  def load_game
  end
end
