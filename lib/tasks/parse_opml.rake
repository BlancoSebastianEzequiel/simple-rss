namespace :opml do
  desc "This task parse an opml file and subscribe user to each of them"
  task :parse, [:file, :users] => :environment do |task, args|
    require 'opml-parser'
    require 'colorize'
    include OpmlParser

    file_name = args.file
    users_names = args.users.split(" ")

    file = File.open(file_name)
    content = file.readlines.join("")
    outlines = OpmlParser.import(content)
    users_names.each do |user_name|
      user = User.find_by(user_name: user_name)
      if user.nil?
        puts "user #{user_name} does not exist"
        file.close
        break
      end
      puts "-----------------Processing user: #{user_name}-----------------"
      outlines.each do |feed|
        next unless feed.attributes.include?(:xmlUrl)
        url = feed.attributes[:xmlUrl.to_sym]
        print "processing feed #{url} =>  "
        res = FeedFactory.create(user, url)
        if res[:status] == :created
          puts "#{res[:json]}".blue
        else
          puts "#{res[:json][:errors][:url]}".red
        end
      end
    end
    file.close
  end
end
