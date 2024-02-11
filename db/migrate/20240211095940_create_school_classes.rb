class CreateSchoolClasses < ActiveRecord::Migration[7.0]
  def change
    create_table :school_classes do |t|
      t.integer :number, null: false
      t.string :letter, null: false

      t.references :school, foreigin_key: true

      t.timestamps
    end
  end
end
