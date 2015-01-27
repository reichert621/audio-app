namespace :parse_text do
  desc "Parse Money Trees"
  task money_trees: :environment do
    text = Text.find_or_create_by!(name: "Money Trees", author: "Kendrick Lamar")
    text_file = File.readlines("#{Rails.root}/lib/assets/money_trees.txt")

    chapters = Hash.new("")
    current_chapter = ""

    text_file.each do |line|
      if line.include?("[")
        current_chapter = line.strip[1..-2]
      else
        chapters[current_chapter] += line
      end
    end

    chapter_rank = 1
    chapters.each do |verse, lyrics|
      ch = text.chapters.find_or_create_by!(name: verse, rank: chapter_rank)
      e = ch.excerpts.find_or_initialize_by(text_id: text.id, rank: 1)
      e.content = lyrics
      e.save!
      chapter_rank += 1
    end

  end
end