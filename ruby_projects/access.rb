#クラスの作成
class Car
    def initialize(name)
        @name = name
    end
    
    def say
      hello
    end
    
    private
      def hello
          puts "Hello I am #{@name}."
      end
      
      def hello2
      end
end

car = Car.new('Kitt')
car.say
