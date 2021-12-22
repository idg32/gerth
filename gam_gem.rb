require 'cli_pix'
require 'rubygems'
require 'terminal-display-colors'

class World
    attr_accessor :people, :quests, :location, :appearance, :image

    def initialize()
        @people = Array.new
        @quests = Array.new
        @location = "Tavern of Drugra"
        @appearance = Array.new
        @appearance = "tavern.png"
        @image = CliPix::Image.from_file(@appearance, autoscale: false)
        #@appearance = [
        #    "##############",
        #    "#    B |     #",
        #    "#------      #",
        #    "#            #",
        #    "#            #",
        #    "#--| |-------#"
        # ]
    end

    def seed_world(id_t,npc_1)
        #@appearance[id_t.y][id_t.x] = id_t.draw
        #@appearance[npc_1.y][npc_1.x] = npc_1.draw
    end

    def update_graphics(id_t)
        #@appearance[id_t.y][id_t.x] = id_t.draw
        #@appearance[id_t.l_y][id_t.l_x] = " "
    end
end

class Player
    attr_accessor :quest_log, :draw, :x, :y, :commands, :l_x, :l_y, :name, :indexer, :self, :question_who

    def initialize()
        @quest_log = Array.new
        @draw = "@"
        @x = 4
        @y = 4
        @l_x = @x 
        @l_y = @y
        @commands = []
        @name = "mystery"
        ind = []
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
    attr_accessor :type, :draw, :x, :y, :name, :index_of_dia, :flair_text, :appearance, :image, :vector, :dialogue

    def initialize(x,y,draw,type,dia)
        @x = x
        @y = y
        @draw = draw 
        @type = type
        @dialogue = dia
        @index_of_dia = -1
        @vector = get_character_portrait()
        @flair_text = "Well there oh you.."
        @name = ["Bobly","Ross","Vossen"].sample
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
        @flair_text = ""
        if @index_of_dia > @dialogue.length - 1
            $new_game.selection = nil 
            $new_game.room_off = false
        end
    end

    def get_character_portrait()
        @appearance = "wizard.png"
        @image = CliPix::Image.from_file(@appearance, autoscale: false)
        return @image
        #     "            ",
        #     '   ^^  ^^   ',
        #     ' %^^^^^^^^% ',
        #     '/##/#||#\#\#',
        #     "|#--#||#--#|",
        #     "[<o>^||^<o>]",
        #     " #---<>---# ",
        #     "  (------)  ",
        #     "   __##__   "
        # ] if @type == "wizard"
    end
end

class Game
    attr_accessor :home_world, :dungeon, :game_king_or_queen, :input, :update_t_f, :current_world, :current_quest

    def initialize()
        @home_world = World.new
        @current_world = @home_world
        @game_king_or_queen = Player.new
        @wilzard = Characters.new(12,4,"%","wizard",["Hey.", "Who?", "Want to find a wench?",""])
        @home_world.seed_world(@game_king_or_queen, @wilzard)
        @game_king_or_queen.commands << @wilzard.draw + " - " + @wilzard.type
        @input = ""
        @update_t_f = true
        @selection = nil
        @room_off = false
        @current_quest = ""
        tick()
    end

    def display_room()
        @current_world.image.display
        #puts @home_world.appearance
    end

    def display_self()
        puts "You are: " + @game_king_or_queen.name.green + " in the " + @home_world.location + " on a quest for: " + @current_quest
    end

    def display_character(chr)
        chr.vector.display      
        puts chr.flair_text + " " + chr.dialogue[chr.index_of_dia]
        @game_king_or_queen.update_commands(chr.get_ind)
    end

    def display_commands()
        puts @game_king_or_queen.commands
    end

    def set_name(name)
        @game_king_or_queen.name = name
    end

    def reset_from_chr_to_room()
        @room_off = false 
        @selection.index_of_dia = 2
        @selection = nil
    end

    def get_input()
        @input = gets.chomp
        puts @input.upcase
        case @input.upcase
        when "%"
            @room_off = true
            @selection = @wilzard
        when "QUIT"
            @update_t_f = false
            puts "Fairwell o' Strange One..."
        when "NO"
            reset_from_chr_to_room()
        when "YES"
            @selection.flair_text = "Go find her, lad..."
            @current_quest = "Find the WENCH!"
            @game_king_or_queen.commands = ["CONTINUE"]
        else
            puts @selection.index_of_dia.to_s + "ind"
            set_name(@input) if @selection.index_of_dia == 1
            @game_king_or_queen.push_interaction(@input.upcase,@selection) if @selection.index_of_dia != 1
            if @selection.index_of_dia == 3
               reset_from_chr_to_room()
            end
        end
        @selection.update_dialogue() if @selection != nil
    end

    def tick()
        system 'clear'
        display_room() if !@room_off
        display_character(@selection) if @selection != nil
        display_self()
        display_commands()
        get_input()
        #@selection.flair_text = "" if @selection != nil
        if @update_t_f == true 
            update()
        end 
    end

    def update()
        tick()
    end
end


$new_game = Game.new 
