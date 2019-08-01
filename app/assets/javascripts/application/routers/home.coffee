class App.Routers.Home extends App.Router

  routes:
    "": "index"
    "signup": "signup"
    "login": "login"

  index: ->
    model = new App.Models.Home {urlRoot: "/"}
    view = new App.Views.Home(model: model, router: this)
    $('body').html(view.el)
    view.render()

  signup: ->
    model = new App.Models.Signup {urlRoot: "/signup"}
    view = new App.Views.Signup(model: model, router: this)
    $('body').html(view.el)
    view.render()

  login: ->
    model = new App.Models.Login {urlRoot: "/login"}
    view = new App.Views.Login(model: model, router: this)
    $('body').html(view.el)
    view.render()

  start: ->
    Backbone.history.start pushState: false

