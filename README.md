# simple-rss

* System dependencies 
  * Install RVM following these instructions: `https://rvm.io/rvm/install`
  * Ruby version `2.6.3`
  * Install nvm following these instructions: `https://github.com/nvm-sh/nvm#installation-and-update`
  * Install Node 8: `nvm install 8`  
* Configuration
  * Clone the repository by typing: `git clone https://gitlab.devartis.com/sblanco/simple-rss.git`
  * Stand on the repository root path: `cd simple-rss`
  * Install bundle: `gem install bundler`
  * Install dependencies: `bundle install`
  * Migrate development database: `rake db:migrate RAILS_ENV=development`
  * Migrate test database: `rake db:migrate RAILS_ENV=test` 

* run tests
  * `bundle exec rspec`
* Run server
  * Run server `rails s`
  * Open browser on  `localhost:3000`
 