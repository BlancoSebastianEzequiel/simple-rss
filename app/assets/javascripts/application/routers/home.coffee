class App.Routers.Home extends App.Router

  routes:
    "": "index"
    "signup": "signup"
    "login": "login"
    "logged": "logged"
    "articles": "articles"

  index: ->
    view = new App.Views.Home()
    $('body').html(view.el)
    view.render()

  signup: ->
    model = new App.Models.Signup
    view = new App.Views.Signup(model: model)
    $('body').html(view.el)
    view.render()

  login: ->
    view = new App.Views.Login(model: new App.Models.Session)
    $('body').html(view.el)
    view.render()

  logged: ->
    view = new App.Views.LoggedNavBar(model: new App.Models.Session)
    $('body').html(view.el)
    view.render()

  articles: ->
    view = new App.Views.Articles(collection: new App.Collections.Articles)
    $('body').html(view.el)
    view.render()

  start: ->
    Backbone.history.start pushState: false

