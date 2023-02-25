# frozen_string_literal: true

BATCH_SIZE = 1000

class CsvController < ApplicationController
  def upload
    file = params[:file].tempfile
    
    CSV.foreach(file.path, headers: true) do |row|
      ActiveRecord::Base.transaction do
        covid_observation = row.to_hash

        CovidObservation.create!(
          observation_date: covid_observation['ObservationDate'].present? ? format_observation_date(covid_observation['ObservationDate']) : nil,
          state: covid_observation['Province/State'].present? ? covid_observation['Province/State'] : nil,
          country: covid_observation['Country/Region'].present? ? covid_observation['Country/Region'] : nil,
          last_update: covid_observation['Last Update'].present? ? format_last_update(covid_observation['Last Update']) : nil,
          confirmed: covid_observation['Confirmed'].present? ? covid_observation['Confirmed'] : nil,
          deaths: covid_observation['Deaths'].present? ? covid_observation['Deaths'] : nil,
          recovered: covid_observation['Recovered'].present? ? covid_observation['Recovered'] : nil
        )

        if covid_observation['SNo'] % BATCH_SIZE == 0
          sleep(0.1)
        end
      rescue StandardError => e
        puts "Error in line #{covid_observation['SNo']}: #{e.message}"
      end
    end
  end

  private

  def format_observation_date(observation_date)
    observation_date_parts = observation_date.split("/")
    observation_date_parts[0] = "0#{observation_date_parts[0]}" if observation_date_parts[0].size == 1
    observation_date = "#{observation_date_parts[2]}/#{observation_date_parts[0]}/#{observation_date_parts[1]}"

    Date.parse(observation_date)
  end

  def format_last_update(last_update)
    if last_update.include?("/")
      last_update_parts = last_update.split(" ")
      date_parts = last_update_parts[0].split("/")

      date_parts[0] = "0#{date_parts[0]}" if date_parts[0].size == 1
      date_parts[2] = "20#{date_parts[2]}" if date_parts[2].size == 2

      last_update_parts[0] = date_parts.join("/")
      last_update = last_update_parts.join(" ")
    end

    if last_update.include?("T")
      last_update = last_update.gsub("T", " ")
    end

    if last_update.match?(/^\d{1,2}\/\d{1,2}\/\d{4}\s\d{1,2}:\d{2}$/)
      DateTime.strptime(last_update, "%m/%d/%Y %H:%M")
    elsif last_update.match?(/^\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}$/)
      DateTime.strptime(last_update, "%Y-%m-%d %H:%M:%S")
    elsif last_update.match?(/^\d{1,2}\/\d{1,2}\/\d{2}\s\d{1,2}:\d{2}$/)
      DateTime.strptime(last_update, "%m/%d/%y %H:%M")
    else
      nil
    end
  end
end
