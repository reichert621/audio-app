namespace :parse_text do
  desc "Parse Aesop's Fables"
  task aesops_fables: :environment do
    text = Text.find_or_create_by!(name: "Aesop's Fables", author: "Aesop")
    text_file = File.readlines("#{Rails.root}/lib/assets/aesops_fables.txt")

    # This book has a preface so we'll start there
    current_chapter = "THE FOX AND THE GRAPES"

    # Split text file into paragraphs
    paragraphs = text_file.split("\r\n").map { |p| p.map(&:strip).join(" ") }

    # Flag to ignore irrelevant content, e.g. credits at beginning and end
    book_content = false

    # Hash to store chapters and content
    chapters = {}

    paragraphs.each do |line|
      # Start tracking content after Preface and before the End
      book_content = true if line.include?("THE FOX AND THE GRAPES")
      book_content = false if line.include?("ILLUSTRATIONS")
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

    rank = 0
    chapters.each do |title, content|
      content = content.join(" ").strip
      chapters[title] = content
      if content.present?
        rank += 1
        chapter = text.chapters.find_or_create_by!(name: title, rank: rank)
        chapter.excerpts.find_or_create_by!(text_id: text.id, content: content, rank: 1)
      end
    end
  end
end