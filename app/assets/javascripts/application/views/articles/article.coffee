class App.Views.Article extends App.View

  template: JST['application/templates/article']

  initialize: ->
    @model.on("hide", this.remove, this)
    @readButton = new App.Views.ReadButton(model: @model)

  render: ->
    link = @model.get("article").link
    title = @model.get("article").title
    read = "&#10004;" if (@model.get("read"))
    imageURL = @model.get("article").avatar || @model.get("avatar")
    description = @model.get("article").description
    @$el.html(@template({ link, title, read, imageURL, description }))
    @$el.find("#read_button").html(@readButton.render().el)
    this
