class App.Views.Articles extends App.View

  template: JST['application/templates/article_list']

  events:
    'click .refresh_articles': "refreshArticles"

  initialize: ->
    @collection.on('add', this.addOne, this)
    #@collection.on('change', this.addAll, this)
    @logout = new App.Views.Logout(model: new App.Models.Session)
    this.getArticles()

  addOne: (articleItem) ->
    articleView = new App.Views.Article(model: articleItem)
    @$el.find("#article_list").append(articleView.render().el)

  addAll: ->
    @numberOfArticles = @collection.models.length
    @$el.html(@template({ @numberOfArticles }))
    @$el.find("#nav_bar").html(@logout.render().el)
    @collection.forEach(this.addOne, this)

  save: ->
    article = new App.Models.Article
    article.save("article",
      { feed_id: localStorage.getItem("current_feed_id") }, {
      method: "patch"
      success: (model, response, options) =>
        alert("success")
        this.getArticles()
      error: (error) ->
        alert("ERROR: " + JSON.stringify(error))
    })

  refreshArticles: (event) ->
    event.preventDefault()
    this.save()

  getArticles: ->
    @collection.fetch({
      data: { feed_id: localStorage.getItem("current_feed_id") }
      success: (model, response, options) =>
        alert("success fetch")
      error: (error) ->
        alert(JSON.stringify(error))
    })
    .then(() => this.addAll())

  render: ->
    this.addAll()
    this