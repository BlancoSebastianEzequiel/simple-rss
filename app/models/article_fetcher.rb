class ArticleFetcher

  def self.fetch(feed, current_user)
    articles = []
    get_articles(feed.url, feed.id).each do |article_data|
      article = Article.where(:link => article_data[:link]).first_or_create(article_data)
      article.users << current_user unless article.users.include? current_user
      unless article.update(article_data)
        raise StandardError.new(article.errors.as_json)
      end
      articles << article
    end
    articles
  end

  private
  #..
  # item: [:itunes_keywords=, :itunes_keywords, :itunes_keywords_content, :date, :itunes_subtitle, :itunes_subtitle=, :
  # source=, :itunes_summary, :description, :itunes_summary=, :itunes_duration=, :content_encoded, :content_encoded=, 
  # :link=, :pubDate, :pubDate=, :author=, :guid, :dc_titles, :dc_title, :dc_title=, :set_dc_title, :enclosure, 
  # :dc_descriptions, :category, :dc_description=, :set_dc_description, :dc_description, :dc_creators, :dc_creator, 
  # :dc_creator=, :set_dc_creator, :dc_subjects, :dc_subject, :dc_subject=, :set_dc_subject, :dc_publishers, 
  # :dc_publisher, :dc_publisher=, :set_dc_publisher, :dc_contributors, :dc_contributor, :dc_contributor=, 
  # :set_dc_contributor, :dc_types, :dc_type, :dc_type=, :set_dc_type, :dc_formats, :dc_format, :dc_format=, 
  # :set_dc_format, :link, :dc_identifiers, :dc_identifier=, :set_dc_identifier, :dc_identifier, :dc_sources, 
  # :dc_source, :dc_source=, :set_dc_source, :source, :dc_languages, :dc_language, :dc_language=, :set_dc_language, 
  # :dc_relations, :dc_relation, :dc_relation=, :set_dc_relation, :categories, :dc_coverages, :category=, 
  # :set_category, :enclosure=, :dc_coverage, :dc_coverage=, :set_dc_coverage, :dc_rights_list, :set_dc_rights, 
  # :dc_rights, :dc_rights=, :dc_date, :set_dc_date, :dc_date=, :set_trackback_about, :dc_rightses, 
  # :date_without_dc_date=, :trackback_ping=, :date=, :comments=, :title=, :trackback_ping, :guid=, 
  # :trackback_abouts, :trackback_about, :trackback_about=, :description=, :comments, :dc_dates, :author, 
  # :itunes_name=, :itunes_email=, :itunes_name, :itunes_email, :itunes_duration, :title, :itunes_author, 
  # :itunes_author=, :itunes_block=, :itunes_block, :itunes_block?, :itunes_explicit=, :itunes_explicit, 
  # :itunes_explicit?, :do_validate=, :validate_for_stream, :set_next_element, :to_s, :converter=, 
  # :have_xml_content?, :need_base64_encode?, :parent, :parent=, :valid?, :have_required_elements?, 
  # :full_name, :do_validate, :tag_name, :convert, :validate, :setup_maker, :to_json, :dclone, :instance_values, 
  # :instance_variable_names, :blank?, :as_json, :acts_like?, :html_safe?, :deep_dup, :duplicable?, :with_options, 
  # :in?, :`, :presence_in, :present?, :presence, :to_yaml, :to_param, :to_query, :pretty_print_instance_variables, 
  # :pretty_print_inspect, :pretty_print, :pretty_print_cycle, :try, :try!, :load_dependency, :unloadable, 
  # :require_or_load, :require_dependency, :instance_variable_defined?, :remove_instance_variable, :instance_of?, 
  # :kind_of?, :is_a?, :tap, :instance_variable_set, :protected_methods, :instance_variables, :instance_variable_get, 
  # :private_methods, :public_methods, :public_send, :method, :public_method, :singleton_method, :class_eval,
  # :pretty_inspect, :define_singleton_method, :extend, :byebug, :remote_byebug, :debugger, :to_enum,
  # :enum_for, :<=>, :===, :=~, :!~, :eql?, :respond_to?, :gem, :freeze, :inspect, :object_id, :send,
  # :display, :nil?, :hash, :class, :singleton_class, :clone, :dup, :itself, :yield_self, :then, :taint,
  # :tainted?, :untaint, :untrust, :untrusted?, :trust, :frozen?, :methods, :singleton_methods, :==, :!=,
  # :null_object?, :received_message?, :stub, :equal?, :!, :should, :as_null_object, :should_not, :instance_eval,
  # :instance_exec, :__id__, :should_receive, :should_not_receive, :unstub, :stub_chain, :__send__]
  #

  def self.get_articles(url, feed_id)
    open(url) do |rss|
      feed = RSS::Parser.parse(rss)
      articles = []
      feed.items.each do |item|
        article = {
            feed_id: feed_id,
            link: item.link,
            title: item.title,
            description: item.description
        }
        article[:avatar] = image_url(item)
        articles << article
      end
      articles
    end
  end

  def self.image_url(item)
    return item.enclosure.url unless item.enclosure.nil?
    if item.description.include?("src")
      require 'nokogiri'
      doc = Nokogiri::HTML(item.description)
      doc.xpath("//img")[0]['src']
    end
  end
end