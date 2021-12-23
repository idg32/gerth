=begin
This is a simple chat bot a(i) for use in a video game.
It uses simple regex and string/array search functions,
to parse a return phrase to the user.
It's a work in progress...
signed, Indiana, GRD

=end


#This is essentially all known key_words to the bot...
def key_words()
    included_intro_words = [
        "HI",
        "WELCOME",
        "SALUTATIONS",
        "HELLO"
    ]
    included_prepositions = [
        "WHEN",
        "WHERE",
        "WHY",
        "HOW"
    ]
    included_pronoun_self = [
        "I",
        "ME",
        "MY",
        "I'M"
    ]
    included_pronoun_identitifier = [
        "YOU",
        "YOUR",
        "YOURS",
        "YOU'RE"
    ]
    return dictionary = [included_intro_words, included_prepositions, included_pronoun_self, included_pronoun_identitifier]
end

#All know replies, etc...
def return_phrases()
    to_intros = Hash.new
    to_preposiions = Hash.new
    to_pronoun_self = Hash.new
    to_pronoun_id = Hash.new
    
    to_intros["HI"] = "Thank you!"
    to_intros["WELCOME"] = "Well I shall stay, I think..."
    to_intros["SALUTATIONS"] = "Fancy meeting you here!"
    to_intros["HELLO"] = "You informal SNOT!"

    to_preposiions["WHEN"] = "I'll tell ya tommorra "
    to_preposiions["WHERE"] = "For the St. Louis team "
    to_preposiions["WHY"] = "Wendnesday is why "
    to_preposiions["HOW"] = "Empty your pockets is how "

    to_pronoun_self["I"] = "You must'nt "
    to_pronoun_self["MY"] = "Well I see, you are "
    to_pronoun_self["ME"] = "Nonsense with your "
    to_pronoun_self["I'M"] = "May I know why "

    return phrase_boook = [to_intros,to_preposiions,to_pronoun_self]
end

def find_key_word(inp)
    dict = key_words()
    counter = 0
    retener = ""
    for j in 0..3
        counter = 0
        while counter < dict[j].length
            if inp.include?(dict[j][counter])
                outsider = inp.each do |i| 
                    #puts i + " I"
                    if i.include?(dict[j][counter])
                        #puts i, j
                        retener += i + " "
                        #retener += return_phrases(i,j) + " "
                    end
                end
            else
            end
            counter += 1
        end
    end
    retener = produce_syntax(retener,dict)
    return retener
end

def produce_syntax(key_words,diction)
    reply = return_phrases()
    for i in 0..diction[0].length - 1
        key_words.gsub(diction[0][i], reply[0]["HI"])
    end
    puts key_words
    return key_words
end

def make_loop_start()
    inputs = gets.gsub(/[!@#$%^&*()-=_+|;':",.<>?']/, '').chomp.upcase.split
    make_loop_mid(inputs)
end

def make_loop_mid(inputs)
    puts find_key_word(inputs)
    goto_end_er() unless inputs.include?("QUIT")
end

def goto_end_er()
    make_loop_start()
end

make_loop_start()