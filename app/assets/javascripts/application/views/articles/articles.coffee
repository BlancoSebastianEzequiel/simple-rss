class App.Views.Articles extends App.View

  template: JST['application/templates/article_list']

  initialize: ->
    @collection.on('add', this.addOne, this)
    @numberOfArticles = @collection.models.length
    this.listenTo(App.Events, "articles:refresh", this.render)

  render: ->
    this.getArticles()
    .then(() =>
      @$el.html(@template({ @numberOfArticles }))
      feedId = localStorage.getItem("current_feed_id")
      refreshArticlesButton = new App.Views.RefreshArticles({ feed_id: feedId })
      @$el.find("#refresh_articles_button").html(refreshArticlesButton.render().el)
      this.addAll()
    )
    this

  addOne: (articleItem) ->
    articleView = new App.Views.Article(model: articleItem)
    @$el.find("#article_list").append(articleView.render().el)

  addAll: ->
    @collection.forEach(this.addOne, this)

  getArticles: ->
    @collection.fetch({
      data: { feed_id: localStorage.getItem("current_feed_id") }
      success: (model, response, options) =>
        @numberOfArticles = response[0].number_of_articles
        new PNotify(text: "success fetch", type: 'success').get()
      error: (error) ->
        new PNotify(text: JSON.stringify(error), type: 'error').get()
    })
