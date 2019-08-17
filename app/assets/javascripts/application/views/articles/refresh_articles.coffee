class App.Views.RefreshArticles extends App.View

  template: JST['application/templates/articles/refresh_articles_button']

  events:
    'click .refreshArticles': "refreshArticles"

  initialize: (options) ->
    @feedId = options.feed_id

  render: ->
    @$el.html(@template({ @feedId }))
    @refreshButton = @$el.find("#refresh_articles_#{@feedId}")
    this.toggleEnabled(@refreshButton, true)
    this

  save: ->
    article = new App.Models.Article
    article.save("article",
      { feed_id: @feedId }, {
        method: "patch"
        success: (model, response, options) =>
          new PNotify(text: "Now you have the latest articles!", type: 'success').get()
          this.toggleEnabled(@refreshButton, true)
          this.trigger("articles:refresh")
        error: (error) =>
          this.toggleEnabled(@refreshButton, true)
          new PNotify(text: "refresh error: " + JSON.stringify(error), type: 'error').get()
      })

  refreshArticles: (event) ->
    event.preventDefault()
    this.toggleEnabled(@refreshButton, false)
    this.save()
