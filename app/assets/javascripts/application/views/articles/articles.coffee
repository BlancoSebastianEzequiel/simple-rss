class App.Views.Articles extends App.View

  template: JST['application/templates/articles/article_list']

  initialize: (options) ->
    @feedTitle = options.feedTitle
    @feedId = options.feedId
    @collection.on('add', this.addOne, this)
    @collection.on('reset', this.addAll, this)

  render: ->
    this.getArticles()
    .then(() =>
      @$el.html(@template({ @numberOfArticles, @feedTitle }))
      refreshArticlesButton = new App.Views.RefreshArticles({ feed_id: @feedId })
      this.listenTo(refreshArticlesButton, "articles:refresh", this.render)
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
      data: { feed_id: @feedId }
      success: (model, response, options) =>
        @numberOfArticles = response[0].number_of_articles
        new PNotify(text: "success fetch", type: 'success').get()
      error: (error) ->
        new PNotify(text: JSON.stringify(error), type: 'error').get()
    })
