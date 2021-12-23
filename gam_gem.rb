require 'cli_pix'
require 'rubygems'
require 'terminal-display-colors'
require_relative './player_diction.rb'
require_relative './npc.rb'

puts "#"

class World
    attr_accessor :people, :quests, :location, :appearance, :image, :description, :dialogue

    def initialize()
        @people = Array.new
        @quests = Array.new
        @location = "Tavern of Drugra"
        @appearance = Array.new
        @appearance = "tavern.png"
        @image = CliPix::Image.from_file(@appearance, autoscale: false)
        @description = "A dank bar, full of nearly no one, save for a busty set bar maid, and a wierdly looking man in the corner."
        @dialogue = ""
    end
end

class Player < Classless_Wordlist
    attr_accessor :quest_log, :draw, :x, :y, :commands, :l_x, :l_y, :name, :indexer, :self, :question_who, :words_list

    def initialize()
        super
        @quest_log = Array.new
        @draw = "@"
        @x = 4
        @y = 4
        @l_x = @x 
        @l_y = @y
        @commands = []
        @name = "mystery"
        ind = []
        #@words_list = Classless_Wordlist::words_list
    end

    def push_interaction(ind,pers)
        #ind = ind.downcase
        @question_how = false
        @question_who = false
        # ind = ind.split(/ /)
        puts ind.include? "WHO"
        @question_who = true if ind.include? "WHO"
        @question_how = true if ind.include? "HOW"
        @self = true if ind.include? "YOU"
        pers.tell_self() if @self && @question_who
        pers.tell_well_being() if @self && @question_how
    end

    def get_world_description(wrld)
        @commands << wrld.description
    end

    def update_commands(ind_npx)
        case ind_npx
        when 1
            @commands = ["N - Name yourself:", "B - Balx'ax", "I - Isac"]
        else
            @commands = ["Type something..."]
        end
    end
end

class Characters
    attr_accessor :type, :draw, :x, :y, :name, :index_of_dia, :flair_text, :appearance, :image, :vector, :dialogue, :list_word

    def initialize(x,y,draw,type,dia,appearance)
        @x = x
        @y = y
        @draw = draw 
        @type = type
        @dialogue = dia
        @index_of_dia = -1
        @vector = get_character_portrait()
        @flair_text = "Well there oh you.."
        @name = ["Bobly","Ross","Vossen"].sample
        @appearance = appearance
        @image = CliPix::Image.from_file(@appearance, autoscale: false)
        tavern_1() if @type == "bar keep"
    end

    def render_character()
        puts @vector
        sleep(1)
        push_dialogue()
    end

    def tell_well_being()
        @flair_text = "I'm doing " + ["well","poorly"].sample
    end

    def tell_self()
        @flair_text = "I'm the " + @type
    end

    def push_dialogue()
        puts @name.red + ": " + @dialogue[@index_of_dia]
    end

    def get_ind()
        return @index_of_dia
    end

    def update_dialogue()
        @index_of_dia += 1
        if @index_of_dia > @dialogue.length - 1
            $new_game.reset_select()
        end
    end

    def get_character_portrait()
        return @image
    end

    def tavern_1()
        @list_word = TavernofDrugra.new
        @list_word = @list_word.tavern_1()
    end
end

class Game
    attr_accessor :home_world, :dungeon, :game_king_or_queen, :input, :update_t_f, :current_world, :current_quest, :display_log, :dialogue_log
    attr_accessor :worlds_listing, :characters_met

    def initialize()
        @home_world = World.new
        @current_world = @home_world
        @game_king_or_queen = Player.new
        @wilzard = Characters.new(12,4,"%","wizard",["Hey.", "Now, who are you?", "Want to find a wench?",""],"wizard.png")
        @bar_keep = Characters.new(12,4,"B","bar keep",["Hey.", "Now, who are you?", "Want to find a wench?",""],"wizard.png")
        @bar_keep.name = "Rillia Orthonol"
        seed_world(@bar_keep)
        #@game_king_or_queen.commands << @wilzard.draw + " - " + @wilzard.type
        @input = ""
        @update_t_f = true
        @selection = nil
        @room_off = false
        @current_quest = ""
        @display_log = false
        @dialogue_log = []
        tick()
    end

    def seed_world(id_t)
        id_t.tavern_1()
    end

    def reset_select()
        selection = nil 
        room_off = false
    end

    def display_room()
        @current_world.image.display
        puts @current_world.dialogue
        #puts @home_world.appearance
    end

    def display_self()
        puts "You are: " + @game_king_or_queen.name.green + " in the " + @home_world.location + " on a quest for: " + @current_quest
    end

    def parse_to_log(text)
        @dialogue_log << text
    end

    def display_character(chr)
        chr.vector.display      
        puts chr.name.red + chr.flair_text + " " + chr.dialogue[chr.index_of_dia]
        chr.flair_text = ""
        @game_king_or_queen.update_commands(chr.get_ind)
    end

    def display_commands()
        puts @dialogue_log if @display_log
        puts @game_king_or_queen.commands
    end

    def set_name(name)
        @game_king_or_queen.name = name
    end

    def reset_from_chr_to_room()
        @room_off = false 
        @selection.index_of_dia = 2
        @selection.flair_text = ""
        @selection = nil
    end

    def get_room_data()
        @input = @input.upcase.gsub(/[!@#$%^&*()-=_+|;':",.<>?']/, '')
        #puts @input
        get = @bar_keep.list_word
        inder = @input.split.each_slice(2).map{|a|a.join ' '}
        #puts get , "list"
        for j in 0...@game_king_or_queen.words_list.size
            for k in 0...inder.length
                if (@game_king_or_queen.words_list.key?(inder[k]))
                    #puts @game_king_or_queen.words_list[inder[k]]
                    @current_world.dialogue += get[@game_king_or_queen.words_list[inder[k]]] 
                    return true
                else
                    @current_world.dialogue = ["Well tis a lovely time here... Can't wait for those rats to barge in...", 
                        "Who's a stranger to you!",
                        "Haven't got a quiet evening yet!"
                    ].sample
                end
            end
            #
        end
        @update_t_f = false if @input.match?("QUIT")
    end

    def get_input()
        @input = gets.chomp
        
        if !@room_off
            get_room_data()
        else 
            have_conversation()
        end
        @selection.update_dialogue() if @selection != nil && !@display_log
        parse_to_log(@input)
        parse_to_log(@selection.flair_text ) if @selection != nil
    end

    def tick()
        display_room() if !@room_off
        display_character(@selection) if @selection != nil
        display_self()
        display_commands()
        puts @display_log = false if @display_log
        get_input()
        if @update_t_f == true && !@input.match?("QUIT")
            update()
        end 
    end

    def update()
        tick()
    end
end


$new_game = Game.new 
