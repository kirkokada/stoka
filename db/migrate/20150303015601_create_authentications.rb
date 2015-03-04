class CreateAuthentications < ActiveRecord::Migration
  def change
    create_table :authentications do |t|
      t.integer :user_id
      t.string :provider
      t.string :uid
      t.string :token
      t.string :secret

      t.timestamps null: false
    end

    add_index :authentications, [:user_id, :provider, :uid, :token, :secret], unique: true, name: 'omniauth_index'
  end
end
