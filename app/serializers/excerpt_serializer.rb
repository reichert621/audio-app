class ExcerptSerializer < ActiveModel::Serializer
  attributes :id, :text_id, :chapter_id, :rank, :content, :likes,
            :chapter_name

  def likes
    object.favorites
  end

  def chapter_name
    object.chapter.name
  end
end
