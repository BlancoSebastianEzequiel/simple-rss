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
    feedId = localStorage.getItem("current_feed_id")
    feedTitle = localStorage.getItem("current_feed_title")
    main = new App.Views.Main
    view = new App.Views.Articles(
      collection: new App.Collections.Articles,
      feedId: feedId,
      feedTitle: feedTitle
    )
    $('body').html(main.el)
    main.render()
    main.append(view)

  start: ->
    Backbone.history.start pushState: false

