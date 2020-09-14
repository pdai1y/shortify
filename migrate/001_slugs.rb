# frozen_string_literal: true

Sequel.migration do
  change do
    create_table(:slugs) do
      primary_key :id
      String :name, null: false
      String :url, null: false
      Boolean :active, null: false, default: true
    end
  end
end
