class App.Routers.Home extends App.Router

  routes:
    "": "index"
    "signup": "signup"
    "login": "login"
    "logged": "logged"

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
    App.Sessions.Session = new App.Models.Session {urlRoot: "/sessions"}
    view = new App.Views.Login(model: App.Sessions.Session, router: this)
    $('body').html(view.el)
    view.render()

  logged: ->
    view = new App.Views.LoggedNavBar(model: App.Sessions.Session)
    $('body').html(view.el)
    view.render()

  start: ->
    Backbone.history.start pushState: false

