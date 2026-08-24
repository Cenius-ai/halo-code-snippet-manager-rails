class Snippet < ApplicationRecord
  before_create :generate_short_code

  validates :content, presence: true
  validates :short_code, uniqueness: true

  scope :recent, -> { order(created_at: :desc).limit(20) }

  LANGUAGES = %w[ruby python javascript html css sql bash json yaml xml go rust php java c markdown plaintext].freeze

  def language_display
    language.presence || "plaintext"
  end

  def title_display
    title.presence || "Untitled snippet"
  end

  def to_param
    short_code
  end

  private

  def generate_short_code
    loop do
      self.short_code = SecureRandom.urlsafe_base64(6)
      break unless Snippet.exists?(short_code: short_code)
    end
  end
end
