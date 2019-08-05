class App.Views.LoggedNavBar extends App.View

  template: JST['application/templates/logged_nav_bar']

  events:
    'click #logout': 'logout'
    'click #get_feeds': 'showFeeds'
    'click #post_feeds': 'postFeeds'
    'click #new_feed_submit': 'saveFeed'
    'click .unsubscribe': 'unsubscribeFeed'
    'click .get_articles': 'getArticles'
    'click .refresh_articles': "refreshArticles"

  initialize: ->
    @feedsList = new App.Collections.Feeds
    @feedsView = new App.Views.Feeds(collection: @feedsList)
    @feedsForm = new App.Views.FeedForm(collection: @feedsList)

    @articlesList = new App.Collections.Articles
    @articlesView = new App.Views.ArticlesList(collection: @articlesList)

  render: ->
    @$el.html(@template)
    this

  showFeeds: ->
    @$el.find("#feed_list").html(@feedsView.render().el)

  postFeeds: ->
    @$el.find("#feed_list").html(@feedsForm.render().el)

  saveFeed: (event) ->
    event.preventDefault()
    newFeed = new App.Models.Feeds { url: $("#input_url").val() }
    newFeed.save(_, _, {
      headers: { "Authorization": localStorage.getItem("auth_token") }
      success: (model, response, options) =>
        alert("success")
        @feedsList.add(newFeed)
      error: (model, error) =>
        alert(JSON.stringify(JSON.parse(error.responseText).errors))
    })
    @$el.find("#feed_list").html(@feedsView.render().el)

  unsubscribeFeed: (event) ->
    event.preventDefault()
    id = event.currentTarget.id
    a_model = @feedsList.get(id)
    a_model.destroy(headers: { "Authorization": localStorage.getItem("auth_token") })

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
