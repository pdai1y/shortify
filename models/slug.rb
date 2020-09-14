# frozen_string_literal: true

require 'securerandom'

class Slug < Sequel::Model
  def before_create
    self.name = generate_random_slug unless name

    self.name = name.to_slug.normalize.to_s
  end

  def validate
    super
    errors.add(:name, 'is already taken') if name && new? && Slug[{name: name}]
    errors.add(:url, 'cannot be empty') if !url || url.empty?
    errors.add(:url, 'is not valid') unless check_url
  end

  private

  def check_url
    uri = URI.parse(url)
    uri.is_a?(URI::HTTP) && !uri.host.nil?
  rescue URI::InvalidURIError
    false
  end

  def generate_random_slug
    self.name = SecureRandom.hex(rand(5..15))
  end
end
