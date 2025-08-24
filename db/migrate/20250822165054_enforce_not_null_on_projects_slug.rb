class EnforceNotNullOnProjectsSlug < ActiveRecord::Migration[7.1]
  def up
    # Sécurise au cas où des slugs seraient vides
    execute <<~SQL
      UPDATE projects
      SET slug = LOWER(REPLACE(title, ' ', '-'))
      WHERE slug IS NULL OR slug = '';
    SQL

    # Interdit les NULL
    change_column_null :projects, :slug, false
  end

  def down
    change_column_null :projects, :slug, true
  end
end
