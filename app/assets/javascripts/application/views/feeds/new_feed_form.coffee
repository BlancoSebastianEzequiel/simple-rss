class App.Views.NewFeedForm extends App.View

  template: JST['application/templates/feed_form']

  events:
    'click #new_feed_submit': 'saveFeed'

  render: ->
    urlError = @collection.errors.url if @collection.errors
    @$el.html(@template({ urlError }))
    this

  saveFeed: (event) ->
    event.preventDefault()
    @collection.save()
    .fail(() => this.render())
    .then(() => this.render())
