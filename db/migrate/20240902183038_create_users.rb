class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users, id: :uuid do |t|
      t.string :email, index: { unique: true, name: 'unique_emails' }

      t.timestamps
    end
  end
end
