class User
    def initialize(name)
        @name = name
    end
    
    def hello
        puts "Hello! I am #{@name}."
    end
end

#子クラスは<で作成
class AdminUser < User
    def admin_hello 
        puts "hello! I am #{@name} from AdminUser."
    end
    
    #オーバーライド
    def hello
        puts "Admin!"
    end
end

nakamura = User.new("Nakamura")
nakamura.hello

sato = AdminUser.new("sato")
sato.hello