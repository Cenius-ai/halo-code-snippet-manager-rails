class CreateSnippets < ActiveRecord::Migration[7.2]
  def change
    create_table :snippets do |t|
      t.string :short_code, null: false
      t.text :content, null: false
      t.string :language
      t.string :title

      t.timestamps
    end
    add_index :snippets, :short_code, unique: true
    add_index :snippets, :created_at
  end
end
