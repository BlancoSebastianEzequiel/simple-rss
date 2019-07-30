class App.Routers.Home extends App.Router

  routes:
    "" : "index"

  index: ->
    model = new App.Models.Home { id: 1, notes: "Welcome to a simple rss implementation!!!!" }
    view = new App.Views.Home.Index(model: model)
    $('body').html(view.el)
    view.render()
