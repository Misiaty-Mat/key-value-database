# frozen_string_literal: true

require './memory'

COMMAND_LIST = %w[SET GET DELETE COUNT].freeze
memory = Memory.new

loop do
  print '> '
  $stdout.flush
  user_input = gets.chomp

  if user_input.empty?
    puts 'NO COMMAND GIVEN'
    next
  end

  command = user_input.split(' ')
  command_keyword = command[0].downcase

  begin
    response = memory.send(command_keyword, *command[1..])
    puts response if response.is_a?(String) || response.is_a?(Integer)
  rescue ArgumentError => e
    puts e.message.capitalize
  rescue NoMethodError => e
    puts "Undefined method \"#{command_keyword.upcase}\""
  end
end
