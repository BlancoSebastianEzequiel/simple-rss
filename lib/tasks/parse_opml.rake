namespace :opml do
  desc "This task does nothing"
  task :parse, [:file, :users] => :environment do |task, args|
    require 'opml-parser'
    include OpmlParser

    # rails "opml:parse[hola, juan seba]"
    file_name = args.file
    users_names = args.users.split(" ")

    file = File.open(file_name)
    content = file.readlines.join("")
    outlines = OpmlParser.import(content)
    users_names.each do |user_name|
      user = User.find_by(user_name: user_name)
      outlines.each do |feed|
        params = { feed: { url: feed.attributes[:htmlUrl.to_sym] } }
        res = FeedFactory.create(user, params)
        if res[:status] == :created
          puts "#{res[:json]}"
        else
          puts "ERROR: #{res[:json][:errors]}"
        end
      end
    end
    file.close
  end
end
