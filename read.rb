# encoding: utf-8
# XXX/ Этот код необходим только при использовании русских букв на Windows
if (Gem.win_platform?)
  Encoding.default_external = Encoding.find(Encoding.locale_charmap)
  Encoding.default_internal = __ENCODING__

  [STDIN, STDOUT].each do |io|
    io.set_encoding(Encoding.default_external, Encoding.default_internal)
  end
end
# /XXX


require_relative 'post.rb'
require_relative 'link.rb'
require_relative 'task.rb'
require_relative 'memo.rb'

# id, limit, type

require 'optparse'

#Все наши опции будут записаны сюда
options = {}

OptionParser.new do |opt|
  opt.banner = 'Usage: read.rb [options]'

  opt.on('h', 'Prints this help') do
    puts opt
    exit

  end

  opt.on('--type POST_TYPE', 'which kinds of posts to show (random default)') { |o| options[:type] = o } #
  opt.on('--id POST_ID', 'if id - show only current post') { |o| options[:id] = o } #
  opt.on('--limit NUMBER', 'how much latest post to show (all by default)') { |o| options[:limit] = o } #

end.parse!

result = Post.find(options[:limit], options[:type], options[:id])

if result.is_a? Post
  puts "Note #{result.class.name}, id = #{options[:id]}"

  result.to_strings.each do |lines|
    puts line
  end

else # покажем таблицу результатов

  print "| id\t| @type\t| @created_at\t\t\t| @text \t\t\t| @url\t\t| @due_date \t"

  result.each do |row|
    puts

    row.each do |element|
      print "| #{element.to_s.delete("\\n\\r")[0..40]}\t"

    end


  end

end

puts

