class App.Views.Article extends App.View

  template: JST['application/templates/article_list']

  initialize: ->
    @model.on("hide", this.remove, this)

  render: ->
    link = @model.get("url")
    title = @model.get("title")
    id = @model.get("id")
    @$el.html(@template({ link, title, id }))
    this
