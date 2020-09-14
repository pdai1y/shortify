# frozen_string_literal: true

require 'spec_helper'

RSpec.describe :Shortify do
  include Rack::Test::Methods

  let(:app) { APP }

  describe 'get /' do
    context 'with a slug' do
      context 'active in the database' do
        before do
          create(:slug)
          get('/test-slug')
        end

        it 'returns the status 302' do
          expect(last_response.status).to eq(302)
        end

        it 'sets the location to google.com' do
          expect(last_response.location).to eq('https://google.com')
        end
      end

      context 'inactive in the database' do
        before do
          create(:slug, :inactive)
          get('/test-slug')
        end

        it 'returns an error message in the body' do
          expect(last_response.body).to eq('The requested slug was not located or has expired.')
        end
      end

      context "doesn't exist in the database" do
        it 'returns an error message in the body' do
          get '/fake-slug'
          expect(last_response.body).to eq('The requested slug was not located or has expired.')
        end
      end
    end

    context 'without a slug' do
      before { get('/') }

      it 'returns the status 404' do
        expect(last_response.status).to eq 404
      end
    end
  end

  describe 'post /api/slugs' do
    let(:json_params) do
      {
        name: nil,
        url: 'https://google.com'
      }
    end

    context 'with a url param' do
      it 'returns a shortened url with a random slug' do
        post('/api/slugs', json_params)

        response_body = JSON.parse(last_response.body)
        url = "http://example.org/#{response_body['slug']}"

        expect(response_body['url']).to eq(url)
      end
    end

    context 'with an invalid url param' do
      it 'returns an error' do
        post('/api/slugs', json_params.merge(url: 'htt://google.com'))

        response_body = JSON.parse(last_response.body)

        expect(response_body['message']).to eq('url is not valid')
      end
    end

    context 'without a url param' do
      it 'returns an error' do
        post('/api/slugs')

        response_body = JSON.parse(last_response.body)

        expect(response_body['message']).to eq('url cannot be empty, url is not valid')
      end
    end

    context 'with a url & name param' do
      context "name doesn't exist in the database" do
        it 'returns a shortened url with a custom slug' do
          post('/api/slugs', json_params.merge(name: 'test-slug'))

          response_body = JSON.parse(last_response.body)

          expect(response_body['url']).to eq('http://example.org/test-slug')
        end
      end

      context "name already exists in the database" do
        it 'returns an error' do
          create(:slug, name: 'test-slug')

          post('/api/slugs', json_params.merge(name: 'test-slug'))

          response_body = JSON.parse(last_response.body)

          expect(response_body['message']).to eq('name is already taken')
        end
      end
    end
  end

  describe 'delete /api/slugs' do
    let(:json_params) do
      {
        name: 'test-slug'
      }
    end

    before do
      create(:slug)
    end

    context 'with a name param' do
      it 'returns an ok status' do
        delete('/api/slugs', json_params)

        response_body = JSON.parse(last_response.body)

        expect(response_body['status']).to eq('ok')
      end
    end

    context 'without a name param' do
      it 'returns an error status' do
        delete('/api/slugs')

        response_body = JSON.parse(last_response.body)

        expect(response_body['status']).to eq('error')
      end

      it 'returns an error message' do
        delete('/api/slugs')

        response_body = JSON.parse(last_response.body)

        expect(response_body['message']).to eq('Slug could not be expired.')
      end
    end
  end
end
