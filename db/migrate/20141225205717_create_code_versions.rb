class CreateCodeVersions < ActiveRecord::Migration
  def change
    create_table :code_versions do |t|
      t.text :code
      t.references :job, index: true, null: false

      t.timestamps null: false
    end
    add_foreign_key :code_versions, :jobs
  end
end
