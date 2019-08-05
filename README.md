# simple-rss

* Ruby version `2.6.3`

* System dependencies 
  * Install RVM following these instructions: `https://rvm.io/rvm/install`
  * OS: Ubuntu 18
  * Install `curl`
  * Install nvm: `curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash`
  * Install Node 8: `nvm install 8`  
* Configuration
  * Clone the repository by typing: `git clone https://gitlab.devartis.com/sblanco/simple-rss.git`
  * stand on the repository root path: `cd simple-rss`
  * Install dependencies: `bundle install`
  * Migrate development database: `rake db:migrate RAILS_ENV=development`
  * Migrate test database: `rake db:migrate RAILS_ENV=test` 

* run tests
  * `bundle exec rspec`
* Run server
  * Run server `rails s`
  * Open browser on  `localhost:3000`
 