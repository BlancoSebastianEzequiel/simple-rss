class App.Views.Feeds extends App.View

  template: JST['application/templates/login_form']

  initialize: ->
    @collection.on('add', this.addOne, this)
    @collection.on('reset', this.addAll, this)

  addOne: (feedItem) ->
    feedView = new App.Views.Feed(model: feedItem)
    @.$el.append(feedView.render().el)

  addAll: ->
    @collection.forEach(this.addOne, this)

  render: ->
    @collection.fetch({
      headers: { "Authorization": localStorage.getItem("auth_token") }
      reset: true
    })
    this