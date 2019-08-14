class App.Views.UnsubscribeConfirmation extends App.View

  template: JST['application/templates/unsubscribe_confirmation']

  render: ->
    @$el.html(@template)
    this
