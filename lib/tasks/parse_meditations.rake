namespace :parse_text do
  desc "Parse Meditations of Marcus Aurelius"
  task meditations: :environment do
    text = Text.find_or_create_by!(name: "Meditations", author: "Marcus Aurelius")
    text_file = File.readlines("#{Rails.root}/lib/assets/meditations.txt")

    # Flag for which chapter to start at
    current_chapter = "THE FIRST BOOK"

    # Split text file into paragraphs
    paragraphs = text_file.split("\r\n").map { |p| p.map(&:strip).join(" ") }

    # Flag to ignore irrelevant content, e.g. credits at beginning and end
    book_content = false

    # Hash to store chapters and content
    chapters = {}

    paragraphs.each do |line|
      # Start tracking content after Introduction and before the End
      book_content = true if line.include?(current_chapter)
      book_content = false if line.include?("APPENDIX")
      if book_content
        if line.present? && (line == line.upcase)
          current_chapter = line
          next
        end
        # If chapter key doesn't exist, create a new empty array
        # where we can then store the next paragraph
        chapters[current_chapter] ||= []
        chapters[current_chapter] << line
      end
    end

    # Time to extract excerpts from each chapter to break the text down
    # into more readable chunks
    chapters.keys.each_with_index do |ch, index|
      chapter = text.chapters.find_or_create_by!(name: ch, rank: index)

      excerpt_rank = 0

      chapters[ch].each do |p|
        if p.present?
          excerpt_rank += 1
          chapter.excerpts.find_or_create_by!(text_id: text.id, content: p, rank: excerpt_rank)
        end
      end
    end
  end
end