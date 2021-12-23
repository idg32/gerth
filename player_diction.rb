class Classless_Wordlist
    attr_accessor :words_list
    def initialize
        @words_list = {
            "WHERES MY" => :get,
            "WHERE AM"  => :here, 
            "WHO ARE"   => :you,
            "WHO IS"    => :them, 
            "WHY IS"    => :this,
            "IS NOT"    => :negative
        }
    end
end