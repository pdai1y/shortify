# frozen_string_literal: true

require 'babosa'
require 'roda'

require_relative 'config/db'
require_relative 'models/slug'
require_relative 'lib/shortener'

class Shortify < Roda
  plugin :json
  plugin :json_parser
  plugin :all_verbs
  plugin :halt
  plugin :hooks

  before do
    return unless request.params

    slug_params(request)
    link_url(request)
  end

  route do |r|
    r.is String do |url_slug|
      # Break out early if no slug was supplied
      r.halt(404) unless url_slug

      slug = Slug.find(name: url_slug)

      r.redirect slug.url and return if slug && slug.active

      'The requested slug was not located or has expired.'
    end

    r.on 'api' do
      r.on 'slugs' do
        r.post do
          shortener.create_slug(name: @name, url: @url)
        end

        r.delete do
          shortener.expire_slug(name: @name)
        end
      end
    end
  end

  private

  def link_url(request)
    @base_url = request.base_url
  end

  def slug_params(request)
    @name = request.params['name']
    @url = request.params['url']
  end

  def shortener
    Shortener.new(base_url: @base_url)
  end
end

run Shortify.freeze.app
