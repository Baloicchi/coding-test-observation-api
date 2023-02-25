class CreateCovidObservations < ActiveRecord::Migration[6.0]
  def change
    create_table :covid_observations do |t|
      t.date :observation_date
      t.string :state
      t.string :country
      t.datetime :last_update
      t.integer :confirmed
      t.integer :deaths
      t.integer :recovered

      t.timestamps null: false
    end
  end
end
