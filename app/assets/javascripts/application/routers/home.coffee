class App.Routers.Home extends App.Router

  routes:
    "": "index"

  index: ->
    model = new App.Models.Home {urlRoot: "/signup"}
    view = new App.Views.Home.IndexView(model: model)
    $('body').html(view.el)
    view.render()

  start: ->
    Backbone.history.start pushState: true

