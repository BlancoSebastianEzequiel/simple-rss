class App.Views.NewFeedForm extends App.View

  template: JST['application/templates/feed_form']

  events:
    'click #new_feed_submit': 'saveFeed'

  render: ->
    @$el.html(@template)
    this

  saveFeed: (event) ->
    event.preventDefault()
    @collection.save()
    this.render()
