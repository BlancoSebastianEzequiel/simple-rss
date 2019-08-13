class App.Routers.Home extends App.Router

  routes:
    "": "index"
    "articles": "articles"

  index: ->
    if localStorage.getItem("auth_token") == "null"
      this.guest()
    else
      this.logged()


  guest: ->
    view = new App.Views.GuestNavBar()
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

