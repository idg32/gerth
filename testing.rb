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
        "HOW",
        "WHO"
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
    included_verbs_self = [
        "AM",
        "WAS"
    ]
    return dictionary = [included_intro_words, included_prepositions, included_pronoun_self, included_pronoun_identitifier,included_verbs_self]
end

#All known replies, etc...
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
    to_preposiions["WHO"] = "It isn't that imporant! "

    to_pronoun_self["I"] = "You "
    to_pronoun_self["MY"] = "Well I see, you are "
    to_pronoun_self["ME"] = "Nonsense with your "
    to_pronoun_self["I'M"] = "May I know why "

    return phrase_boook = [to_intros,to_preposiions,to_pronoun_self]
end

def find_key_word(inp)
    dict = key_words()
    counter = 0
    retener = ""
    for j in 0..4
        counter = 0
        until counter == dict[j].length
            if inp.include?(dict[j][counter])
                outsider = inp.each do |i| 
                    #puts i + " I"
                    if i.include?(dict[j][counter])
                        #puts i, j
                        retener += i + " " if !retener.include?(i)
                        #retener += return_phrases(i,j) + " "
                    end
                end
            else
            end
            counter += 1
        end
    end
    retener = produce_syntax(retener,dict,inp) unless retener == ""
    return retener
end

def logic_here(words,term)
    ret = ""
    for i in 0..words.length - 1
        ret = words[i+1] if words[i].include?(term)
    end
    return ret
end

def produce_syntax(key_words,diction,origin)
    reply = return_phrases()
    #    [i]self, them[you]
    flag = [false,false]
    puts key_words
    maker = key_words.split(' ')
    for i in 0..2
        for k in 0..maker.length - 1
            varent = maker[k]
            #puts varent
            key_words.gsub!(origin[k],reply[i][varent]) unless reply[i][varent] == nil
        end
    end
    return key_words
end

def make_loop_start()
    inputs = gets.gsub(/[!@#$%^&*()-=_+|;':",.<>?']/, '').chomp.upcase.split
    make_loop_mid(inputs)
end

def make_loop_mid(inputs)
    puts find_key_word(inputs) unless find_key_word(inputs) == ""
    goto_end_er() unless inputs.include?("QUIT")
end

def goto_end_er()
    make_loop_start()
end

make_loop_start()