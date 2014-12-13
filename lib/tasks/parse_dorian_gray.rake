namespace :parse_text do
  desc "Parse Dorian Gray into excerpts"
  task dorian_gray: :environment do
    text = Text.find_or_create_by!(name: "The Picture of Dorian Gray", author: "Oscar Wilde")
    text_file = File.readlines("#{Rails.root}/lib/assets/dorian_gray.txt")

    # This book has a preface so we'll start there
    current_chapter = "THE PREFACE"

    # Split text file into paragraphs
    paragraphs = text_file.split("\r\n").map { |p| p.map(&:strip).join(" ") }

    # Flag to ignore irrelevant content, e.g. credits at beginning and end
    book_content = false

    # Hash to store chapters and content
    chapter = {}

    paragraphs.each do |line|
      # Start tracking content after Preface and before the End
      book_content = true if line.include?("PREFACE")
      book_content = false if line.include?("End of Project Gutenberg's The Picture of Dorian Gray")
      if book_content
        if line.include?("CHAPTER")
          current_chapter = line
          next
        end
        # If chapter key doesn't exist, create a new empty array
        # where we can then store the next paragraph
        chapter[current_chapter] ||= []
        chapter[current_chapter] << line
      end
    end

    # Time to extract excerpts from each chapter to break the text down
    # into more readable chunks
    chapter.keys.each_with_index do |ch, index|
      _chapter = text.chapters.find_or_create_by!(name: ch, rank: index)

      # We're going to add paragraphs to the exerpt until we hit a min word count
      excerpt = []
      excerpt_word_count = 0
      excerpt_rank = 0

      chapter[ch].each do |p|
        if excerpt_word_count > 250
          # Creates an excerpt for the chapter
          content = excerpt.join("\r\n")
          excerpt_rank += 1
          e = _chapter.excerpts.find_or_initialize_by(text_id: text.id, rank: excerpt_rank)
          e.content = content
          e.save!
          # Clears current excerpt and resets word count
          excerpt = []
          excerpt_word_count = 0
        end
        p_word_count = p.split(" ").count
        excerpt_word_count += p_word_count
        excerpt << p
      end

      # If there is any text leftover at the end, add it to the last excerpt
      # of the chapter. 
      new_content = _chapter.excerpts.last.content += excerpt.join("\r\n")
      _chapter.excerpts.last.update_attributes!(content: new_content)
    end
  end
end