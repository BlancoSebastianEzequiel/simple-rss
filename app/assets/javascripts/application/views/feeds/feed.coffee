class App.Views.Feed extends App.View

  template: JST['application/templates/feeds/feed']

  events:
    'click #unsubscribe': 'confirmUnsubscribeFeed'
    'click #get_articles': 'getArticles'
    "change #checkbox": "selectFeed"

  initialize: ->
    @model.set(select: false)
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
    folders = new App.Views.Folders(collection: new App.Collections.Folders, feedId: @model.get("id"))
    @$el.find("#folders-select").append(folders.render().el)
    this

  unsubscribeFeed: ->
    @model.destroy({
      success: (model, response, options) =>
        new PNotify(text: "all articles deleted", type: 'success').get()
        App.Events.trigger("feed:delete:end")
        this.toggleEnabled(@unsubscribeButton, true)
        App.Events.trigger("feed:empty:message")
      error: (error) ->
        new PNotify(text: JSON.stringify(JSON.parse(error.responseText).errors), type: 'error').get()
    })

  reestablishButtons: ->
    App.Events.trigger("feed:delete:end")
    this.toggleEnabled(@unsubscribeButton, true)

  confirmUnsubscribeFeed: (event) ->
    event.preventDefault()
    this.toggleEnabled(@unsubscribeButton, false)
    App.Events.trigger("feed:delete:start")
    unsubscribeConfirmation = new App.Views.UnsubscribeConfirmation
    @$el.find("#confirmation").html(unsubscribeConfirmation.render().el)
    this.listenTo(unsubscribeConfirmation, "confirm:unsubscribe", this.unsubscribeFeed)
    this.listenTo(unsubscribeConfirmation, "cancel:unsubscribe", this.reestablishButtons)

  getArticles: (event) ->
    event.preventDefault()
    localStorage.setItem("current_feed_id", @model.get("id"))
    localStorage.setItem("current_feed_title", @model.get("title"))
    Backbone.history.navigate("articles", { trigger: true })

  selectFeed: ->
    @model.set(select: !@model.get("select"))
    if @model.get("select")
      this.trigger("feed:selected:true")
    else
      this.trigger("feed:selected:false")
