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
end

car = Car.new('Kitt')
car.hello