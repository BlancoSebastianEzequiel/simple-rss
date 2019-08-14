class App.Views.Article extends App.View

  template: JST['application/templates/article']

  initialize: ->
    @model.on("hide", this.remove, this)
    @readButton = new App.Views.ReadButton(model: @model)

  render: ->
    link = @model.getLink()
    title = @model.getTitle()
    read = "&#10004;" if (@model.getReadValue())
    imageURL = @model.getAvatar()
    description = @model.getDescription()
    @$el.html(@template({ link, title, read, imageURL, description }))
    @$el.find("#read_button").html(@readButton.render().el)
    this
