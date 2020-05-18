class Car
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
        puts "#{@@count} instance."
    end
end
#インスタンスを作成しなければcountは0
Car.info

car = Car.new("sample")
Car.info