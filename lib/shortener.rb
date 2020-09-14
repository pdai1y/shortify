# frozen_string_literal: true

class Shortener
  attr_accessor :base_url

  def initialize(base_url: nil)
    @base_url = base_url
  end

  def create_slug(name: nil, url: nil)
    slug = Slug.create(name: name, url: url)

    generate_hash(status: 'ok', slug: slug.name)
  rescue Sequel::ValidationFailed => e
    generate_hash(status: 'error', message: e.message)
  end

  # Don't delete the slug, just expire it so it won't be served
  def expire_slug(name: nil)
    slug = Slug.find(name: name)

    return generate_hash(status: 'error', message: 'Slug could not be expired.') unless slug

    if slug.update(active: false)
      generate_hash(status: 'ok')
    else
      generate_hash(status: 'error', message: 'Slug could not be expired.')
    end
  end

  private

  def generate_hash(status:, message: nil, url: nil, slug: nil)
    {}.tap do |h|
      h[:status] = status
      h[:message] = message || nil
      if slug
        h[:slug] = slug
        h[:url] = "#{base_url}/#{slug}"
      end
    end
  end
end
