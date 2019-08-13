class App.Routers.Home extends App.Router

  routes:
    "": "index"
    "articles": "articles"

  index: ->
    main = new App.Views.Main
    $('body').html(main.el)
    main.render()
    if App.Sessions.isLogged()
      view = new App.Views.Logged
      main.append(view)

  articles: ->
    main = new App.Views.Main
    view = new App.Views.Articles(collection: new App.Collections.Articles)
    $('body').html(main.el)
    main.render()
    main.append(view)

  start: ->
    Backbone.history.start pushState: false

