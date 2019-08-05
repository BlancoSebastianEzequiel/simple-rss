class App.Views.Feeds extends App.View

  template: JST['application/templates/login_form']

  initialize: ->
    @collection.on('add', this.addOne, this)
    @collection.on('change', this.addAll, this)

  addOne: (feedItem) ->
    feedView = new App.Views.Feed(model: feedItem)
    @$el.append(feedView.render().el)

  addAll: ->
    @collection.forEach(this.addOne, this)

  render: ->
    @collection.fetch()
    this

  save: ->
    feed = new App.Models.Feed { url: $("#input_url").val() }
    feed.save(_, _, {
      success: (model, response, options) =>
        alert("success")
        @collection.add(feed)
      error: (model, error) =>
        alert(JSON.stringify(JSON.parse(error.responseText).errors))
    })