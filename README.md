# simple-rss

* System dependencies 
  * Install RVM following these instructions: `https://rvm.io/rvm/install`
  * Install nvm following these instructions: `https://github.com/nvm-sh/nvm#installation-and-update`
  * Install Node 8: `nvm install 8` 
  * Install bundler: `gem install bundler -v {numero de version}r`
  
* Versions used
   * Ruby: `2.6.3`
   * Rails: `5.2.3`
   * Bundler `1.17.3`
  
* Configuration
  * Clone the repository by typing: `git clone https://gitlab.devartis.com/sblanco/simple-rss.git`
  * Stand on the repository root path: `cd simple-rss`
  * Run : `rvm current` and make sure that you see: `ruby-2.6.3@simple-rss`
  * Install dependencies: `bundle install`
  * Migrate development database: `rake db:migrate RAILS_ENV=development`
  * Migrate test database: `rake db:migrate RAILS_ENV=test` 

* Run tests
  * `bundle exec rspec`
  
* Run server
  * Run server `rails s`
  * Open browser on  `localhost:3000`
 