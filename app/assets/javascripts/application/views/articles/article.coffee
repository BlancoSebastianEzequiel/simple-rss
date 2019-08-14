class App.Views.Article extends App.View

  template: JST['application/templates/article']

  TICK: "&#10004;"

  initialize: ->
    @model.on("hide", this.remove, this)

  render: ->
    link = @model.getLink()
    title = @model.getTitle()
    read = @TICK if (@model.getReadValue())
    imageURL = @model.getAvatar()
    description = @model.getDescription()
    @$el.html(@template({ link, title, read, imageURL, description }))
    readButton = new App.Views.ReadButton(model: @model)
    this.listenTo(readButton, "read:button:marked", this.render)
    @$el.find("#read_button").html(readButton.render().el)
    this
