class App.Views.Feed extends App.View

  template: JST['application/templates/feed']

  initialize: ->
    @model.on("hide", this.remove, this)

  render: ->
    url = @model.get("url")
    title = @model.get("title")
    id = @model.get("id")
    @$el.html(@template({ url, title, id }))
    this
