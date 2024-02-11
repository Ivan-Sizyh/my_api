class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :surname, null: false

      t.references :class, foreign_key: { to_table: :school_classes, column: :class_id }

      t.timestamps
    end
  end
end
