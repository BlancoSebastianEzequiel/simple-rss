class App.Views.Login extends App.View

  template: JST['application/templates/login_form']

  events:
    'click #login_submit': 'login'

  render: ->
    @$el.html(@template)
    @loginButton = @$el.find("#login_submit")
    this.toggleEnabled(@loginButton, true)
    this

  login: =>
    this.toggleEnabled(@loginButton, false)
    @model.set(user_name: $("#input_user_name").val())
    @model.set(password: $("#input_password").val())
    @model.save()
    .success (model, response, options) =>
      this.toggleEnabled(@loginButton, true)
      localStorage.setItem("auth_token", model.auth_token)
      Backbone.history.loadUrl("", { trigger: true })
    .error (error) =>
      alert(JSON.stringify(JSON.parse(error.responseText).errors))
      this.toggleEnabled(@loginButton, true)
