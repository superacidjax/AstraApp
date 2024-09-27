require "test_helper"

class ApplicationRecordTest < ActiveSupport::TestCase
  class UuidModel < ApplicationRecord
    self.table_name = "uuid_models"
  end

  setup do
    ActiveRecord::Schema.define do
      create_table :uuid_models, id: :uuid, force: true do |t|
        t.timestamps
      end
    end
  end

  teardown do
    ActiveRecord::Schema.define do
      drop_table :uuid_models, force: true
    end
  end

  test "should generate UUIDv7 for records with UUID id" do
    model = UuidModel.new
    assert_nil model.id
    model.save!
    assert_not_nil model.id
    assert_match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/, model.id)
  end

  test "should not overwrite UUID if already present" do
    existing_id = UUID7.generate
    model = UuidModel.new(id: existing_id)
    model.save!
    assert_equal existing_id, model.id
  end
end
