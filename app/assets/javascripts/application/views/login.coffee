class App.Views.Login extends App.View

  template: JST['application/templates/login_form']

  events:
    'click #login_submit': 'login'
    "change #input_user_name": "setUsername",
    "change #input_password": "setPassword"

  render: ->
    @$el.html(@template)
    @loginButton = @$el.find("#login_submit")
    this.toggleEnabled(@loginButton, true)
    this

  setUsername: ->
    @model.set(user_name: $("#input_user_name").val())

  setPassword: ->
    @model.set(password: $("#input_password").val())

  login: =>
    this.toggleEnabled(@loginButton, false)
    @model.save()
    .success (model, response, options) =>
      this.toggleEnabled(@loginButton, true)
      localStorage.setItem("auth_token", model.auth_token)
      Backbone.history.navigate("", { trigger: true })
    .error (error) =>
      alert(JSON.stringify(JSON.parse(error.responseText).errors))
      this.toggleEnabled(@loginButton, true)
