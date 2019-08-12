class App.Views.ReadButton extends App.View

  template: JST['application/templates/read_button']

  events:
    'click .read_button': "setRead"

  initialize: ->
    @model.on("hide", this.remove, this)

  setButtonText: (read) ->
    if (read)
      return buttonText = "mark as unread"
    else
      return buttonText = "mark as read"

  render: =>
    @read = @model.get("read")
    buttonText = this.setButtonText(@read)
    id = @model.get("article").id
    @$el.html(@template({ id, buttonText }))
    @readButton = @$el.find("#read_button_#{id}")
    this.toggleEnabled(@readButton, true)
    this

  setRead: ->
    this.toggleEnabled(@readButton, false)
    @model.set(read: !@read)
    articleId = @model.get("article").id
    @model.save({ article_id: articleId,  read: @model.get("read") }, {
      url: @model.urlRoot + '-read'
      method: "patch"
      error: (error) ->
        new PNotify(text: JSON.stringify(error), type: 'error').get()
    })
    .then(() =>
      this.toggleEnabled(@readButton, true)
      Backbone.history.loadUrl()
      this.render()
    )
