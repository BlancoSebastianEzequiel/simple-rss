class App.Views.Articles extends App.View

  template: JST['application/templates/article_list']

  events:
    'click .refresh_articles': "refreshArticles"

  initialize: ->
    @collection.on('add', this.addOne, this)
    @logout = new App.Views.Logout(model: new App.Models.Session)

  render: ->
    this.getArticles()
    .then(() =>
      numberOfArticles = @collection.models.length
      @$el.html(@template({ numberOfArticles }))
      @refreshButton = $(".refresh_articles")
      this.validated(@refreshButton, true)
      @$el.find("#nav_bar").html(@logout.render().el)
      this.addAll()
      this
    )

  addOne: (articleItem) ->
    articleView = new App.Views.Article(model: articleItem)
    @$el.find("#article_list").append(articleView.render().el)

  addAll: ->
    @collection.forEach(this.addOne, this)

  save: ->
    article = new App.Models.Article
    article.save("article",
      { feed_id: localStorage.getItem("current_feed_id") }, {
      method: "patch"
      success: (model, response, options) =>
        new PNotify(text: "Now you have the latest articles!", type: 'success').get()
        this.getArticles().then(() => this.validated(@refreshButton, true))
      error: (error) ->
        new PNotify(text: JSON.stringify(error), type: 'error').get()
    })

  refreshArticles: (event) ->
    event.preventDefault()
    this.validated(@refreshButton, false)
    this.save()

  getArticles: ->
    @collection.fetch({
      data: { feed_id: localStorage.getItem("current_feed_id") }
      success: (model, response, options) =>
        new PNotify(text: "success fetch", type: 'success').get()
      error: (error) ->
        new PNotify(text: JSON.stringify(error), type: 'error').get()
    })
