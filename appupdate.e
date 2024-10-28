class
	APPLICATION

create
	make_and_launch

feature {NONE} -- Initialization

	make_and_launch
		local
			l_app: EV_APPLICATION
		do
				-- Initialize guessed_letters early
			create guessed_letters.make_empty

				-- Create and launch the application
			create l_app
			prepare
			l_app.launch
		end

	prepare
		do
			create first_window
			first_window.set_title ("Snowman Hangman")
			first_window.set_size (1000, 750)

			create canvas
			first_window.put (canvas)

			first_window.show
			make
		end

feature

	first_window: MAIN_WINDOW
	canvas: EV_DRAWING_AREA
	incorrect_guesses: INTEGER -- Tracks incorrect guesses
	guessed_letters: STRING -- Tracks correct guesses
	total_guesses : INTEGER -- Tracks all guesses

feature -- Initialize Game

	make
		local
			dictionary: PLAIN_TEXT_FILE
			words: HASH_TABLE [STRING, INTEGER]
			word_count: INTEGER
			random_word: detachable STRING
		do
				-- Initialize variables and open dictionary file
			create words.make (48000)
			create dictionary.make_open_read ("dictionary.txt")

			if dictionary.is_open_read then
				io.put_string ("Dictionary file opened successfully.%N")
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

				-- Set word count
			word_count := words.count
			io.put_string ("Word count: " + word_count.out + "%N")

				-- Generate a random word from the dictionary
			random_word := generate_random_word (words, word_count)

				-- Ensure random_word is valid
			if attached random_word as non_void_word then

					-- Error checking, need to remove before final game
				io.put_string ("Random word: " + non_void_word + "%N")

				io.put_string ("Length of random word: " + non_void_word.count.out + "%N")
				io.put_string ("%N")

					-- Reinitialize guessed_letters with the length of the random word
				create guessed_letters.make_filled ('_', non_void_word.count)

					-- Print the initial underscores (all underscores since no guesses have been made)
				print_word_tracker

					-- Initialize game state and start game loop
				incorrect_guesses := 0
				total_guesses := 0
				game_loop (non_void_word)
			else
					-- Handle error in case no word is found
				io.put_string ("Error: No word found.%N")
			end
		end

		-- Generate a random word from the dictionary
	generate_random_word (words: HASH_TABLE [STRING, INTEGER]; word_count: INTEGER): detachable STRING
		local
			rng: RANDOM
			time: TIME
			seed, random_index: INTEGER
		do
			create rng.make
			create time.make_now
			seed := time.hour * 3600 + time.minute * 60 + time.second
			rng.set_seed (seed)
			rng.forth
			random_index := rng.item \\ word_count + 1
			Result := words.item (random_index)
		end

		-- Print the current state of the guessed letters (word tracker)
	print_word_tracker
		local
			i: INTEGER
		do
			from
				i := 1
			until
				i > guessed_letters.count
			loop
				io.put_character (guessed_letters.item (i))
				io.put_string (" ")
				i := i + 1
			end
			io.put_string ("%N")
		end

	-- Main loop
game_loop (word: STRING)
	local
		guess: CHARACTER_8
		index: INTEGER
		all_guessed: BOOLEAN
		guess_was_correct: BOOLEAN
		wrong_guess: ARRAY [CHARACTER_8]
		used_guesses: ARRAY [CHARACTER_8]
		i, j: INTEGER
		temp: CHARACTER_8
		already_guessed: BOOLEAN

	do
		all_guessed := False
		create wrong_guess.make (1, 6) -- initial array for incorrect guesses
		create used_guesses.make (1, 30)

		from
		until
			all_guessed or else incorrect_guesses = 6
		loop
			-- Print sorted guesses
			io.put_string ("Previous guesses: ")

			-- Create an array with just the incorrect guesses
			--create used_guesses.make (1, total_guesses)
			--from
			--	i := 1
			--until
			--	i > incorrect_guesses
			--loop
			--	used_guesses.put (wrong_guess.item (i), i)
			--	i := i + 1
			--end

			-- Sort `used_guesses` with bubble sort
			from
				i := 1
			until
				i > total_guesses
			loop
				from
					j := 1
				until
					j > total_guesses - i
				loop
					if used_guesses.item (j) > used_guesses.item (j + 1) then
						-- Swap elements
						temp := used_guesses.item (j)
						used_guesses.put (used_guesses.item (j + 1), j)
						used_guesses.put (temp, j + 1)
					end
					j := j + 1
				end
				i := i + 1
			end

			-- Print each character in sorted `used_guesses`
			from
				i := 1
			until
				i > used_guesses.count
			loop
				if used_guesses.item (i)= "" then

				else
					io.put_character (used_guesses.item (i))
					io.put_character (' ')
					i := i + 1
				end

			end -- end printing sorted wrong guesses
			io.put_new_line

					-- Prompt for user's guess
				io.put_string ("Guess: ")
				io.read_character
				guess := io.lastchar.as_lower

					-- Skip newline character if it is encountered
				if guess = '%N' then
					io.read_character
					guess := io.lastchar.as_lower
				end

				already_guessed := False -- Keep track of if guess already made

					-- Check if correct and reguess
				if guessed_letters.has (guess) then
					already_guessed := True
				else
						-- Check wrong guesses
					from
						i := 1
					until
						i > incorrect_guesses or else already_guessed
					loop
						if wrong_guess.item (i) = guess then
							already_guessed := True

						end
						i := i + 1
					end
				end -- end checks

					-- Guess made already
				if already_guessed then
					io.put_string ("Already guessed! Try again.%N")
				else -- Otherwise continue with game
					if guess.is_alpha or else guess = '%'' or else guess = '-' then -- Apostrophe/hyphen handling

							-- Reset the correct_guess flag at the start of each loop
						guess_was_correct := False

							-- Check if the guessed character is in the word
						from
							index := 1
						until
							index > word.count
						loop
							if word.item (index) = guess then
									-- Update guessed letters for correct guess
								guessed_letters.put (guess, index)
								guess_was_correct := True
							end
							index := index + 1
						end

							-- If the guess was correct, update the word tracker and continue
						if guess_was_correct then
							io.put_string ("Correct guess!%N")
							total_guesses := total_guesses + 1
							used_guesses.put (guess, total_guesses)
						else
								-- Handle incorrect guess by drawing part of the snowman
							incorrect_guesses := incorrect_guesses + 1
							wrong_guess.put (guess, incorrect_guesses) -- Store the incorrect guess in the array
							total_guesses := total_guesses + 1
							used_guesses.put (guess, total_guesses)
							io.put_string ("Incorrect guess! Drawing part of the snowman.%N")
							handle_incorrect_guess
						end

							-- Print the updated word tracker with correctly guessed letters
						print_word_tracker

							-- Check if the player has guessed all letters correctly
						if guessed_letters.is_equal (word) then
							io.put_string ("Congratulations! You guessed the word.%N")
							all_guessed := True
						elseif incorrect_guesses = 6 then
							io.put_string ("Game over! The word was: " + word + "%N")
						end
					else
						io.put_string ("Invalid input. Please enter an alphabetic character or an apostrophe.%N")
					end
				end
			end
		end

		-- Handle drawing the hangman based on incorrect guesses
	handle_incorrect_guess
		do
			if incorrect_guesses = 1 then
				io.put_string ("Drawing base.%N")
				draw_base (canvas, 375, 600, 200, 100)
			elseif incorrect_guesses = 2 then
				io.put_string ("Drawing middle.%N")
				draw_middle (canvas, 400, 525, 150, 75)
			elseif incorrect_guesses = 3 then
				io.put_string ("Drawing top.%N")
				draw_top (canvas, 425, 475, 100, 50)
			elseif incorrect_guesses = 4 then
				io.put_string ("Drawing hat.%N")
				draw_hat (canvas, 415, 455, 120, 20)
			elseif incorrect_guesses = 5 then
				io.put_string ("Drawing right arm.%N")
				draw_right (canvas, 600, 500, 550, 560)
			elseif incorrect_guesses = 6 then
				io.put_string ("Drawing left arm.%N")
				draw_left (canvas, 400, 560, 350, 500)
				io.put_string ("Game over!%N")
			end
		end

feature -- Drawing Functions

	draw_base (board: EV_DRAWING_AREA; x, y, width, height: INTEGER)
		do
			board.draw_ellipse (x, y, width, height)
		end

	draw_middle (board: EV_DRAWING_AREA; x, y, width, height: INTEGER)
		do
			board.draw_ellipse (x, y, width, height)
		end

	draw_top (board: EV_DRAWING_AREA; x, y, width, height: INTEGER)
		do
			board.draw_ellipse (x, y, width, height)
            board.fill_ellipse(455, 485, 10, 10)
            board.fill_ellipse(485, 485, 10, 10)
            board.draw_segment(455, 505, 495, 505)
            board.draw_segment(455, 505, 465, 510)
            board.draw_segment(495, 505, 485, 510)
		end

	draw_hat (board: EV_DRAWING_AREA; x, y, width: INTEGER; height: INTEGER)
		do
			board.fill_rectangle (x, y, width, height)
			board.fill_rectangle (x + 8, y - 21, width - 15, height)
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
