class AddInfoFieldsToProjects < ActiveRecord::Migration[7.2]
  def change
    add_column :projects, :client, :string
    add_column :projects, :year, :string
    add_column :projects, :role, :string
    add_column :projects, :stack, :string
  end
end
