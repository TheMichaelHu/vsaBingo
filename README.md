# vsaBingo
Server based bingo game Rails app, hosted [here](https://salty-thicket-55431.herokuapp.com/).

# Setup
1. install postgreSQL if you don't already have it `gem install psql`
2. create a `vsa_bingo_development` database
..+ `psql postgres`
..+ `postgres=# CREATE DATABASE vsa_bingo_development;`
..+ `postgres=# \q`
3. install gems `bundle install`
4. run migrations `rake db:migrate`
5. start the dev server `rails s`

# Local websocket setup
1. Install and start redis `redis-server /usr/local/etc/redis.conf &`
2. Start the websocket server `rake websocket_rails:start_server`
