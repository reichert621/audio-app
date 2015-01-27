namespace :parse_text do
  desc "Parse MLK's Dream speech"
  task mlk_dream_speech: :environment do
    text = Text.find_or_create_by!(name: "I Have A Dream", author: "Martin Luther King, Jr")
    text_file = File.readlines("#{Rails.root}/lib/assets/mlk_dream_speech.txt")

    chapter = text.chapters.find_or_create_by!(name: "Full Speech", rank: 1)

    excerpt_content = ""
    excerpt_word_count = 0
    excerpt_rank = 1

    text_file.each do |p|
      if excerpt_word_count > 250
        e = chapter.excerpts.find_or_initialize_by(text_id: text.id, rank: excerpt_rank)
        e.content = excerpt_content
        e.save!
        puts "Excerpt #{e.id} saved"

        # Clears current excerpt and resets word count
        excerpt_content = ""
        excerpt_word_count = 0
        excerpt_rank += 1
      else
        excerpt_content += "\n" + p
        excerpt_word_count += p.split(" ").count
      end
    end
  end
end