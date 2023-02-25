Rails.application.routes.draw do
  get 'csv/upload'
  get 'top/confirmed', to: 'covid_observation#get_top_confirmed'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
