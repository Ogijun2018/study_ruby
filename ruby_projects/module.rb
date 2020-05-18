module Driver
    def self.run
        puts "Run"
    end
    
    def self.stop
        puts "Stop"
    end
end

driver = Driver.new
driver.run
# Driver.stop