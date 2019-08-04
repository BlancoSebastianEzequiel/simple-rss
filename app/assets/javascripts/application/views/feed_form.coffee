class App.Views.FeedForm extends App.View

  template: JST['application/templates/feed_form']

  render: ->
    @$el.html(@template)
    this
