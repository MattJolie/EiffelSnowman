note
    description: "SnowmanGame application root class"
    date: "$Date$"
    revision: "$Revision$"

class
    SNOWMAN_GAME

create
    make

feature {NONE} -- Initialization

    make

        local
            dictionary: PLAIN_TEXT_FILE
            words: HASH_TABLE [STRING, INTEGER]
            word_count, random_index: INTEGER
            random_word: detachable STRING
            rng: RANDOM
            time: TIME
            seed: INTEGER
        do
            -- initializes the hash table with a size of 100
            create words.make (48000) -- *** Makes me choose a size, should we work around this?

            -- opens the dictionary file to read
            create dictionary.make_open_read ("dictionary.txt")

            -- creates and seeds the random number generator (rng) [pulled from https://www.eiffel.org/article/random_numbers]
            create rng.make
			create time.make_now
      		seed := time.hour
     		seed := seed * 60 + time.minute
     		seed := seed * 60 + time.second
      		create rng.set_seed (seed)

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

            -- gets the number of words in the hash table and stores it in n
            word_count := words.count
            io.put_string ("Word count: " + word_count.out + "%N")

            -- advances to the next random number
            rng.forth

            -- generates a random index within the range of n
            random_index := rng.item \\ word_count + 1

            -- retrieves the word at the random index
            random_word := words.item (random_index)

            -- uses attached to check if the retrieved word is not void
            if attached random_word as non_void_word then

                -- prints the random word if the word is not void
                io.put_string ("Random word: " + non_void_word + "%N")

            else

                -- prints an error message if the word is void
                io.put_string ("Error: No word found.%N")
            end

            -- *** need to add code to start the game with `random_word`
        end

end
