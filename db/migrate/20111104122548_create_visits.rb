class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits do |t|
      t.integer :visit_type_id, :null => false
      t.integer :doctor_id, :null => false
      t.integer :patient_id, :null => false
      t.date :date
      t.text :notes
      t.decimal :height
      t.decimal :weight
      t.decimal :systolic
      t.decimal :diastolic
      t.decimal :pulse
      t.decimal :temperature

      t.timestamps
    end
  end
end