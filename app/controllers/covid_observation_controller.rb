class CovidObservationController < ApplicationController
  def get_top_confirmed
    observation_date = params[:observation_date]
    max_results = params[:max_results].present? ? params[:max_results].to_i : 10

    raise ActionController::ParameterMissing.new('observation_date') unless observation_date.present?

    covid_observations = CovidObservation
                      .by_observation_date(observation_date)
                      .select("country, SUM(confirmed) AS confirmed, SUM(deaths) AS deaths, SUM(recovered) AS recovered")
                      .group("country")
                      .order("confirmed DESC")
                      .limit(max_results)

    countries = covid_observations.map do |covid_observation|
      {
        country: covid_observation.country,
        confirmed: covid_observation.confirmed,
        deaths: covid_observation.deaths,
        recovered: covid_observation.recovered
      }
    end

    response_json = {
      observation_date: observation_date,
      countries: countries
    }

    render json: response_json, status: :ok
  rescue ActionController::ParameterMissing => e
    render json: { error: e.message }, status: :bad_request
  rescue StandardError => e
    render json: { error: e.message }, status: :internal_server_error
  end
end
