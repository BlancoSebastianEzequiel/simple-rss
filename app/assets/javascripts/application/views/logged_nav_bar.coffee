class App.Views.LoggedNavBar extends App.View

  template: JST['application/templates/logged_nav_bar']

  events:
    'click #logout': 'logout'

  initialize: ->
    @feedsList = new App.Collections.Feeds
    @feedsView = new App.Views.Feeds(collection: @feedsList)
    @newFeedForm = new App.Views.NewFeedForm(collection: @feedsList)

    @articlesList = new App.Collections.Articles
    @articlesView = new App.Views.Articles(collection: @articlesList)

  render: ->
    @$el.html(@template)
    @$el.find("#new_feed_form").html(@newFeedForm.render().el)
    @$el.find("#feed_list").html(@feedsView.render().el)
    this

  logout: ->
    @model.set("id", localStorage.getItem("auth_token"))
    localStorage.setItem("auth_token", null)
    @model.destroy()
    alert("goodbye!")
    Backbone.history.navigate("", { trigger: true })
