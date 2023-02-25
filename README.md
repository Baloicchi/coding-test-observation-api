# README

* Ruby version
2.6.5

* System dependencies

* Configuration

* Database creation
    - bin/rails db:create

* Database initialization
    - bin/rails db:migrate

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

    CSV File Reading:
    - Run the server by invoking rails s
    - In Postman, set the url to 127.0.0.1:3000/csv/upload (GET)
    - In Body > form-data, set the KEY to `file` and change the format to File, for VALUE, click `Select Files` and then choose the csv file. Click `Send` and wait for the parser to read and store the data.

    Searching for top confirmed:
    - In Postman, set the url to 127.0.0.1:3000/top/confirmed (GET)
    - In params, you can set the observation_date and max_results; observation_date is required and max_results is optional (will default to 10 if none passed). Click `Send` and wait for response.
