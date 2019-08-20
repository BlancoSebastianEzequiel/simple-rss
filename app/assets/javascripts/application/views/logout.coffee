class App.Views.Logout extends App.View

  template: JST['application/templates/logout']

  events:
    'click #logout': 'logout'

  render: ->
    @$el.html(@template)
    this

  logout: ->
    @model.set("id", localStorage.getItem("auth_token"))
    localStorage.setItem("auth_token", null)
    @model.destroy().then(() =>
      new PNotify(text: "goodbye!", type: 'success').get()
      Backbone.history.loadUrl("", { trigger: true })
    )
