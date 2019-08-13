class App.Views.RefreshArticles extends App.View

  template: JST['application/templates/refresh_articles_button']

  events:
    'click #refresh_articles': "refreshArticles"

  initialize: (options) ->
    @feedId = options.feed_id

  render: ->
    @$el.html(@template({ @feedId }))
    @refreshButton = $("#refresh_articles")
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
        error: (error) =>
          this.toggleEnabled(@refreshButton, true)
          new PNotify(text: JSON.stringify(error), type: 'error').get()
      })

  refreshArticles: (event) ->
    event.preventDefault()
    this.toggleEnabled(@refreshButton, false)
    this.save()
