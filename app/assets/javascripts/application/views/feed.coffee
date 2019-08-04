class App.Views.Feed extends App.View

  template: JST['application/templates/feed_list']

  render: ->
    url = @model.get("url")
    title = @model.get("title")
    @$el.html(@template({ url, title }))
    this
