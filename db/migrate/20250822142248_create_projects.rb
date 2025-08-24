class CreateProjects < ActiveRecord::Migration[7.2]
  def change
    create_table :projects do |t|
      t.string :title
      t.string :subtitle
      t.text :description
      t.string :techs
      t.string :image_url
      t.string :url
      t.string :github_url
      t.string :slug
      t.integer :position
      t.boolean :published

      t.timestamps
    end
    add_index :projects, :slug, unique: true
  end
end
