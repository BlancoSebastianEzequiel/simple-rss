class App.Views.ArticlesList extends App.View

  initialize: ->
    @collection.on('add', this.addOne, this)
    @collection.on('change', this.addAll, this)

  addOne: (articleItem) ->
    articleView = new App.Views.Article(model: articleItem)
    @.$el.append(articleView.render().el)

  addAll: ->
    @collection.forEach(this.addOne, this)

  save: ->
    a_model = new App.Models.Articles
    a_model.save("article", { feed_id: localStorage.getItem("current_feed_id") }, {
      method: "patch"
      success: (model, response, options) =>
        alert("success")
      error: (error) =>
        alert("ERROR: " + JSON.stringify(error))
    })

  render: ->
    @collection.fetch({
      data: { feed_id: localStorage.getItem("current_feed_id") }
      success: (model, response, options) =>
        alert("success")
      error: (error) =>
        alert(JSON.stringify(error))
    })
    this