#クラスの作成
class Car
    #メソッド
    #initializeという関数はnewが使われた時に最初に呼ばれる特別な関数
    def initialize(name)
        #インスタンス変数
        puts "initialize"
        @name = name
    end
    
    def hello
        puts "Hello I am #{@name}."
    end
    
    #ゲッターメソッド
    # def name
    #     @name
    # end
    
    # #イコールで繋ぐとメソッドに値を代入するようにできるようになる
    # #セッターメソッド
    # def name=(value)
    #     @name = value
    # end
    
    #上の部分はattr_accessorメソッドで代用できる
    attr_accessor :name
    #読み取りだけ実装したい場合は
    #attr_reader :name
    #書き込みだけ実装したい場合は
    # attr_writer :name
end

car = Car.new('Kitt')
car.hello
#car.@nameはできない
puts car.name
car.name = 'nakamura'
puts car.name