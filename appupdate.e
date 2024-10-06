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

            -- Initialize the game
            make
        end

feature -- Variables

    first_window: MAIN_WINDOW
    canvas: EV_DRAWING_AREA
    incorrect_guesses: INTEGER -- Tracks the number of wrong guesses

feature -- Initialize Game


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

                -- Initialize the game state
                incorrect_guesses := 0
                game_loop(non_void_word)

            else
                -- prints an error message if the word is void
                io.put_string ("Error: No word found.%N")
            end
        end

    -- Function to randomly generate a word
    generate_random_word (words: HASH_TABLE [STRING, INTEGER]; word_count: INTEGER): detachable STRING
        local
            rng: RANDOM
            time: TIME
            seed, random_index: INTEGER
        do
            -- creates and seeds the random number generator (rng)
            create rng.make
            create time.make_now
            seed := time.hour * 3600 + time.minute * 60 + time.second
            rng.set_seed (seed)

            -- advances to the next random number
            rng.forth

            -- generates a random index within the range of word_count
            random_index := rng.item \\ word_count + 1

            -- retrieves the word at the random index
            Result := words.item (random_index)
        end

    -- Function to print underscores based on the length of the word
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

    -- Main game loop
    game_loop (word: STRING)
        local
            guess: CHARACTER_8
        do
            -- Example of guessing loop. You would get the actual guess input from the user.
            across
                "abcdefgh" as letter
            loop
            	io.put_string ("Guess: ")
            	io.read_character
            	guess := io.lastchar

                if not word.has (guess) then
                    incorrect_guesses := incorrect_guesses + 1
                    handle_incorrect_guess
                end
            end
        end

    -- Handle drawing based on the number of incorrect guesses
    handle_incorrect_guess
        do
            if incorrect_guesses >= 1 then
                draw_base (canvas, 375, 600, 200, 100)
               end
            if incorrect_guesses >= 2 then
                draw_middle (canvas, 400, 525, 150, 75)
               end
            if incorrect_guesses >= 3 then
                draw_top (canvas, 425, 475, 100, 50)
               end
            if incorrect_guesses >= 4 then
                draw_hat (canvas, 415, 455, 120, 20)
               end
            if incorrect_guesses >= 5 then
                draw_right (canvas, 550, 500, 500, 525)
               end
            if incorrect_guesses = 6 then
                draw_left (canvas, 450, 525, 400, 500)
                io.put_string ("Game over!%N")
            end
        end

feature -- Drawing Functions

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

end -- End of class
