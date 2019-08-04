class App.Views.LoggedNavBar extends App.View

  template: JST['application/templates/logged_nav_bar']

  events:
    'click #logout': 'logout'
    'click #get_feeds': 'showFeeds'
    'click #post_feeds': 'postFeeds'
    'click #new_feed_submit': 'saveFeed'

  initialize: ->
    @feedsList = new App.Collections.Feeds
    @feedsView = new App.Views.Feeds(collection: @feedsList)
    @feedsForm = new App.Views.FeedForm(collection: @feedsList)

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
    newFeed.save(_, { headers: { "Authorization": localStorage.getItem("auth_token") } })
    .success (model, response, options) =>
      alert("success")
    .error (error) =>
      alert(JSON.stringify(JSON.parse(error.responseText).errors))
    @feedsList.add(newFeed)
    @$el.find("#feed_list").html(@feedsView.render().el)

  logout: ->
    @model.set("id", localStorage.getItem("auth_token"))
    @model.destroy()
    alert("goodbye!")
    Backbone.history.navigate("", { trigger: true })
