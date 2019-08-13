class App.Views.Logged extends App.View

  template: JST['application/templates/logged']

  initialize: ->
    @feedsList = new App.Collections.Feeds
    @feedsView = new App.Views.Feeds(collection: @feedsList)
    @newFeedForm = new App.Views.NewFeedForm(collection: @feedsList)
    this.listenTo(App.Events, "feed:delete:start", @newFeedForm.disableButton)
    this.listenTo(App.Events, "feed:delete:end", @newFeedForm.enableButton)

  render: ->
    @$el.html(@template)
    @$el.find("#new_feed_form").html(@newFeedForm.render().el)
    @$el.find("#feed_list").html(@feedsView.render().el)
    this