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
      if user.nil?
        puts "user #{user_name} does not exist"
        file.close
        break
      end
      outlines.each do |feed|
        next unless feed.attributes.include?(:xmlUrl)
        puts "params: #{feed.attributes[:xmlUrl.to_sym]}"
        res = FeedFactory.create(user, feed.attributes[:xmlUrl.to_sym])
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
