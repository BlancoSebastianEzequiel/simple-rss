class App.Views.LoggedNavBar extends App.View

  template: JST['application/templates/logged_nav_bar']

  events:
    'click #logout': 'logout'
    'click #get_feeds': 'showFeeds'
    'click #post_feeds': 'postFeeds'
    'click .unsubscribe': 'unsubscribeFeed'
    'click .get_articles': 'getArticles'
    'click .refresh_articles': "refreshArticles"

  initialize: ->
    @feedsList = new App.Collections.Feeds
    @feedsView = new App.Views.Feeds(collection: @feedsList)
    @newFeedForm = new App.Views.NewFeedForm(collection: @feedsList)

    @articlesList = new App.Collections.Articles
    @articlesView = new App.Views.Articles(collection: @articlesList)

  render: ->
    @$el.html(@template)
    this

  showFeeds: ->
    @$el.find("#feed_list").html(@feedsView.render().el)

  postFeeds: ->
    @$el.find("#feed_list").html(@newFeedForm.render().el)

  unsubscribeFeed: (event) ->
    event.preventDefault()
    id = event.currentTarget.id
    feed = @feedsList.get(id)
    feed.destroy()

  getArticles: (event) ->
    event.preventDefault()
    localStorage.setItem("current_feed_id", event.currentTarget.id)
    @$el.find("#feed_list").html(@articlesView.render().el)

  refreshArticles: (event) ->
    event.preventDefault()
    localStorage.setItem("current_feed_id", event.currentTarget.id)
    @articlesView.save()
    @$el.find("#feed_list").html(@articlesView.render().el)

  logout: ->
    @model.set("id", localStorage.getItem("auth_token"))
    @model.destroy()
    alert("goodbye!")
    Backbone.history.navigate("", { trigger: true })
