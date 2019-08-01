class App.Views.Login extends App.View

  template: JST['application/templates/login_form']

  events:
    'click #login_submit': 'login'

  render: ->
    @$el.html(@template)

  login: ->
    @model.set(session: {
      user_name: $("#input_user_name").val()
      password: $("#input_password").val()
    })
    @model.save()
    .success (res) ->
      alert("success login")
    .error (error) ->
      alert("ERROR")
      alert(JSON.stringify(error.responseText))
    Backbone.history.navigate("", { trigger: true })
