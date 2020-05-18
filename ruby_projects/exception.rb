puts "--- Please enter an integer. ---"
i = gets.to_i

begin
#例外が起こりうる処理
puts 10 / i

#例外が起こった時に使われる関数
rescue => ex
  puts "Error!"
  puts ex.message
  puts ex.class
  
#例外が発生してもしなくても行う処理
ensure
  puts "end"

end