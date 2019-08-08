class App.Views.ReadButton extends App.View

  template: JST['application/templates/read_button']

  events:
    'click #read_button': "setRead"

  initialize: ->
    @model.on("hide", this.remove, this)

  render: ->
    @read = @model.get("read")
    if (@read)
      buttonText = "mark as unread"
    else
      buttonText = "mark as read"
    @$el.html(@template({ buttonText }))
    this

  setRead: ->
    @model.set(read: !@read)
    articleId = @model.get("article").id
    @model.save({ article_id: articleId,  read: @model.get("read") }, {
      url: @model.urlRoot + '-read'
      method: "patch"
      success: (model, response, options) =>
        alert("success read")
      error: (error) ->
        alert("ERROR: " + JSON.stringify(error))
    })
    .then(() =>
      Backbone.history.loadUrl()
      this.render()
    )
