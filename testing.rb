# require 'cli_pix'
# file_path = "green_sq.png"
# image = CliPix::Image.from_file(file_path, autoscale: false)
# #image.size = [2,2]
# image.display

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
        "I'M"
    ]
    included_pronoun_identitifier = [
        "YOU",
        "YOURS",
        "YOU'RE"
    ]
    return dictionary = [included_intro_words, included_prepositions, included_pronoun_self, included_pronoun_identitifier]
end

def return_phrases(send)
    to_intros = Hash.new
    to_intros["HI"] = "Thank you!"
    to_intros["WELCOME"] = "Well I shall stay, I think..."
    to_intros["SALUTATIONS"] = "Fancy meeting you here!"
    to_intros["HELLO"] = "You informal SNOT!"
    
    return to_intros[send]
end

def find_key_word(inp)
    dict = key_words()
    counter = 0
    retener = ""
    while counter < dict[0].length
        if inp.include?(dict[0][counter])
            outsider = inp.each do |i| 
                #puts i + " I"
                if i.include?(dict[0][counter])
                    retener += return_phrases(i) + " "
                end
            end
        else
        end
        counter += 1
    end
    return retner
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