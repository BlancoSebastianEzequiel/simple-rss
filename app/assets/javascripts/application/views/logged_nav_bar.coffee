class App.Views.LoggedNavBar extends App.View

  template: JST['application/templates/logged_nav_bar']

  events:
    'click #logout': 'logout'

  initialize: ->
    @feedsList = new App.Collections.Feeds
    @feedsView = new App.Views.Feeds(collection: @feedsList)
    @newFeedForm = new App.Views.NewFeedForm(collection: @feedsList)
    @logout = new App.Views.Logout(model: new App.Models.Session)

  render: ->
    @$el.html(@template)
    @$el.find("#nav_bar").html(@logout.render().el)
    @$el.find("#new_feed_form").html(@newFeedForm.render().el)
    @$el.find("#feed_list").html(@feedsView.render().el)
    this