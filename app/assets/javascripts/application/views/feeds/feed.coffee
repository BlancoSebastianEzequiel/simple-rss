class App.Views.Feed extends App.View

  template: JST['application/templates/feed']

  events:
    'click #unsubscribe': 'unsubscribeFeed'
    'click #get_articles': 'getArticles'

  initialize: ->
    @model.on("hide", this.remove, this)

  render: ->
    url = @model.get("url")
    title = @model.get("title")
    id = @model.get("id")
    @$el.html(@template({ id, url, title }))
    @unsubscribeButton = @$el.find("#unsubscribe")
    this.toggleEnabled(@unsubscribeButton, true)
    refreshArticlesButton = new App.Views.RefreshArticles({ feed_id: id })
    @$el.find("#refresh_articles_button").html(refreshArticlesButton.render().el)
    this

  unsubscribeFeed: (event) ->
    event.preventDefault()
    this.toggleEnabled(@unsubscribeButton, false)
    App.Events.trigger("feed:delete:start")
    if window.confirm("Do you really unsubscribe?")
      @model.destroy({
        success: (model, response, options) =>
          new PNotify(text: "all articles deleted", type: 'success').get()
          App.Events.trigger("feed:delete:end")
          this.toggleEnabled(@unsubscribeButton, true)
          App.Events.trigger("feed:empty:message")
        error: (error) ->
          new PNotify(text: JSON.stringify(JSON.parse(error.responseText).errors), type: 'error').get()
      })
    else
      App.Events.trigger("feed:delete:end")
      this.toggleEnabled(@unsubscribeButton, true)

  getArticles: (event) ->
    event.preventDefault()
    localStorage.setItem("current_feed_id", $(event.target).data('id'))
    Backbone.history.navigate("articles", { trigger: true })