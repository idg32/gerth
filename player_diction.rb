class Classless_Wordlist
    attr_accessor :words_list
    def initialize
        @words_list = {
            "WHERE'S MY"=> :get,
            "WHERE AM"  => :here, 
            "WHO ARE"   => :you,
            "WHO IS"    => :them, 
            "WHY IS"    => :this,
            "N'T"       => :negative
        }
    end
end