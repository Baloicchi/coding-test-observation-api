# frozen_string_literal: true

class CovidObservation < ApplicationRecord
  scope :by_observation_date, -> (date) { where(observation_date: date) }
end
