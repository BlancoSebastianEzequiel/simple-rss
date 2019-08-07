class App.Views.Article extends App.View

  template: JST['application/templates/article']

  initialize: ->
    @model.on("hide", this.remove, this)

  render: ->
    link = @model.get("article").link
    title = @model.get("article").title
    @$el.html(@template({ link, title }))
    this
