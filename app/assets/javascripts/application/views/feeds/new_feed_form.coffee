class App.Views.NewFeedForm extends App.View

  template: JST['application/templates/feed_form']

  events:
    'click #new_feed_submit': 'saveFeed'

  render: ->
    urlError = @collection.errors.url if @collection.errors
    @$el.html(@template({ urlError }))
    @subscribeButton = @$el.find("#new_feed_submit")
    this.toggleEnabled(@subscribeButton, true)
    this

  enableButton: =>
    this.toggleEnabled(@subscribeButton, true)

  disableButton: =>
    this.toggleEnabled(@subscribeButton, false)

  saveFeed: (event) ->
    event.preventDefault()
    this.toggleEnabled(@subscribeButton, false)
    @collection.save()
    .fail(() => this.render())
    .then(() => this.render())
