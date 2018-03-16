require './lib/modules.rb'
require 'json'

class Game
  include HangMethods

  def initialize (word, veiled_word, current_try, total_tries, save)
    @word = word
    @veiled_word = veiled_word
    @current_try = current_try
    @total_tries = total_tries
    @save = save
    @save_info = []
  end

  def play
    @save_info = play_loop(@total_tries, @current_try, @word, @veiled_word, @save)
  end

  def to_json
    { :word => @word,
      :veiled_word => @veiled_word,
      :current_try => @current_try,
      :total_tries => @total_tries,
      :save => @save}.to_json
  end

  def self.from_json string
    data = JSON.load string
    self.new data['word'], data['veiled_word'], data['current_try'], data['total_tries'], data['save']
  end
end
