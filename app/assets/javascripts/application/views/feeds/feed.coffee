class App.Views.Feed extends App.View

  template: JST['application/templates/feed']

  initialize: ->
    @model.on("hide", this.remove, this)

  render: ->
    url = @model.get("url")
    title = @model.get("title")
    id = @model.get("id")
    @$el.html(@template({ id, url, title }))
    refreshArticlesButton = new App.Views.RefreshArticles({ feed_id: id })
    @$el.find("#refresh_articles_button").html(refreshArticlesButton.render().el)
    this
