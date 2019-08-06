class App.Views.Article extends App.View

  template: JST['application/templates/article']

  initialize: ->
    @model.on("hide", this.remove, this)

  render: ->
    link = @model.get("link")
    title = @model.get("title")
    @$el.html(@template({ link, title }))
    this
