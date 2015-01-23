class CreateExecutionResults < ActiveRecord::Migration
  def change
    create_table :execution_results do |t|
      t.references :job
      t.text :messages
      t.string :status

      t.timestamps null: false
    end
  end
end
