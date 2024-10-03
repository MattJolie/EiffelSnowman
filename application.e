note
    description: "Common Project for Snowman Hangman Game"
    author: "Paul O'Sullivan, Matt Keefe, Matt Jolie"
    date: "9/25/24"
    revision: "1.1.1"

class
    APPLICATION

create
    make_and_launch

feature {NONE} -- Initialization

    make_and_launch
        local
            l_app: EV_APPLICATION
        do
            create l_app
            prepare
            l_app.launch
        end

    prepare
        do
            -- Create and initialize the first window.
            create first_window
            first_window.set_title ("Snowman Hangman")
            first_window.set_size (1000, 750)

            -- Create and initialize the drawing area (canvas).
            create canvas
            first_window.put (canvas)

            -- Show the first window.
            first_window.show

            -- Draw the snowman parts
            draw_snowman(canvas)
        end

feature -- Variables

    first_window: MAIN_WINDOW
    canvas: EV_DRAWING_AREA

feature -- Initalize Game
feature {NONE} -- Initialization

    make
        local
            dictionary: PLAIN_TEXT_FILE
            words: HASH_TABLE [STRING, INTEGER]
            word_count: INTEGER
            random_word: detachable STRING
        do
            -- initializes the hash table with a size of 48000 (word count is 47158)
            create words.make (48000)

            -- opens the dictionary file to read
            create dictionary.make_open_read ("dictionary.txt")

            -- checks if the dictionary file is open
            if dictionary.is_open_read then
                io.put_string ("Dictionary file opened successfully.%N")

                -- reads each line from the file and stores it in the hash table
                from
                    dictionary.read_line
                until
                    dictionary.end_of_file
                loop
                    words.put (dictionary.last_string.twin, words.count + 1)
                    dictionary.read_line
                end

                dictionary.close
            else
                io.put_string ("Error: Cannot open dictionary file.%N")
            end

            -- gets the number of words in the hash table and stores it in word_count
            word_count := words.count
            io.put_string ("Word count: " + word_count.out + "%N")

            -- generates a random word
            random_word := generate_random_word (words, word_count)

            -- uses attached to check if the retrieved word is not void
            if attached random_word as non_void_word then

                -- prints the random word if the word is not void
                io.put_string ("Random word: " + non_void_word + "%N")

                -- prints the length of the random word
                io.put_string ("Length of random word: " + non_void_word.count.out + "%N")

                -- prints a new line and then a number of underscores equal to the length of the random word
                io.put_string ("%N")
                print_underscores (non_void_word.count)

            else

                -- prints an error message if the word is void
                io.put_string ("Error: No word found.%N")

            end
        end

    -- function to randomly generate a word
    feature

        generate_random_word (words: HASH_TABLE [STRING, INTEGER]; word_count: INTEGER): detachable STRING
            local
                rng: RANDOM
                time: TIME
                seed, random_index: INTEGER
            do
                -- creates and seeds the random number generator (rng)
                create rng.make
                create time.make_now
                seed := time.hour
                seed := seed * 60 + time.minute
                seed := seed * 60 + time.second
                create rng.set_seed (seed)

                -- advances to the next random number
                rng.forth

                -- generates a random index within the range of word_count
                random_index := rng.item \\ word_count + 1

                -- retrieves the word at the random index
                Result := words.item (random_index)
            end

    -- function to print underscores based on the length of the word
    feature

        print_underscores (length: INTEGER)
            local
                i: INTEGER
            do
                from
                    i := 1
                until
                    i > length
                loop
                    io.put_string ("_ ")
                    i := i + 1
                end
                io.put_string ("%N")
            end

	feature 
		local
			alphabet_list: ARRAYED_LIST [STRING_8]
			i: INTEGER_32
			letter_state: ARRAYED_LIST [CHARACTER_8]
			guess : STRING
			do
				create alphabet_list.make (27);
				alphabet_list.put_front ("A");
				alphabet_list.force ("B");
				alphabet_list.force ("C");
				alphabet_list.force ("D");
				alphabet_list.force ("E");
				alphabet_list.force ("F");
				alphabet_list.force ("G");
				alphabet_list.force ("H");
				alphabet_list.force ("I");
				alphabet_list.force ("J");
				alphabet_list.force ("K");
				alphabet_list.force ("L");
				alphabet_list.force ("M");
				alphabet_list.force ("N");
				alphabet_list.force ("O");
				alphabet_list.force ("P");
				alphabet_list.force ("Q");
				alphabet_list.force ("R");
				alphabet_list.force ("S");
				alphabet_list.force ("T");
				alphabet_list.force ("U");
				alphabet_list.force ("V");
				alphabet_list.force ("W");
				alphabet_list.force ("X");
				alphabet_list.force ("Y");
				alphabet_list.force ("Z");
				alphabet_list.force ("'")
				create letter_state.make (27)
				from
					i := 1
					until
						i > 27
						loop
							letter_state.force ('n')
							i := i + 1
						end
						print (letter_state.full)
						print (alphabet_list.has("A"))

						guess := "h" --User input, hopefully from the game
						if not(alphabet_list.has(guess)) then
							print("Try again, this is not a valid answer")
							elseif letter_state.i_th (alphabet_list.index_of (guess, 1))= 'i' then
							print("You have already made this incorrect guess, try again")
							elseif letter_state.i_th (alphabet_list.index_of (guess, 1))= 'c' then
							print("You have already guessed this correctly, try again")
							elseif letter_state.i_th (alphabet_list.index_of (guess, 1))= 'n' then
							if true then -- letter in word
							letter_state.put_i_th ('c', alphabet_list.index_of (guess, 1))
							-- make every instance of the letter visible
							else
								letter_state.put_i_th ('i', alphabet_list.index_of (guess, 1))s






feature -- Drawing Functions

    draw_snowman (drawing_zone: EV_DRAWING_AREA)
        do
            draw_base(drawing_zone, 375, 600, 200, 100) -- 400, 600, 200, 100
            draw_middle(drawing_zone, 400, 525, 150, 75) -- 400, 515, 150, 75
            draw_top(drawing_zone, 425, 475, 100, 50) -- 400, 455, 100, 50
            draw_hat(drawing_zone, 415, 455, 120, 20)
            draw_left(drawing_zone, 450, 525, 400, 500)
            draw_right(drawing_zone, 550, 500, 500, 525)
        end

    draw_base (board: EV_DRAWING_AREA; x, y, width, height: INTEGER)
        do
            board.draw_ellipse(x, y, width, height)
        end

    draw_middle (board: EV_DRAWING_AREA; x, y, width, height: INTEGER)
        do
            board.draw_ellipse(x, y, width, height)
        end

    draw_top (board: EV_DRAWING_AREA; x, y, width, height: INTEGER)
        do
            board.draw_ellipse(x, y, width, height)
        end

	draw_hat (board: EV_DRAWING_AREA; x, y, width: INTEGER; height: INTEGER)
    	do
        	board.fill_rectangle(x, y, width, height) -- bottom
        	board.fill_rectangle(x + 8, y - 21, width - 15 , height) -- top
    	end

    draw_left (board: EV_DRAWING_AREA; xi, yi, xf, yf: INTEGER)
    	do
    		board.draw_segment (xi, yi, xf, yf)
    	end

    draw_right (board: EV_DRAWING_AREA; xi, yi, xf, yf: INTEGER)
    	do
    		board.draw_segment (xi, yi, xf, yf)
    	end


end -- End of project
