class Car
    #定数は大文字
    REGION = 'USA'
    #クラス変数
    @@count = 0
    def initialize(name)
        @name = name
        #インスタンスが作成された回数が記録
        @@count += 1
    end
    
    def hello
        puts "Hello I am #{@name}. #{@@count} instance(s)."
    end
    
    #クラスメソッドはselfをつける
    def self.info
        puts "#{@@count} instance. Region: #{REGION}"
    end
end
#インスタンスを作成しなければcountは0
Car.info

car = Car.new("sample")
Car.info

#クラス中の定数を呼び出すときはコロン二つ
puts Car::REGION