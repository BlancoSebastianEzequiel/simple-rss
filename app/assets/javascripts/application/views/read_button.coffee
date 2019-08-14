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
    @read = @model.getReadValue()
    buttonText = this.setButtonText(@read)
    id = @model.getId()
    @$el.html(@template({ id, buttonText }))
    @readButton = @$el.find("#read_button_#{id}")
    this.toggleEnabled(@readButton, true)
    this

  setRead: (event) ->
    event.preventDefault()
    this.toggleEnabled(@readButton, false)
    @model.set(read: !@read)
    articleId = @model.getId()
    @model.save({ article_id: articleId,  read: @model.get("read") }, {
      url: @model.urlRoot + '-read'
      method: "patch"
      success: (model, response, options) =>
        this.toggleEnabled(@readButton, true)
        this.render()
        this.trigger("read:button:marked")
      error: (error) ->
        new PNotify(text: JSON.stringify(error), type: 'error').get()
    })
