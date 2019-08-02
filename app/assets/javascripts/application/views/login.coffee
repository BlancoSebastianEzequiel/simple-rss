class App.Views.Login extends App.View

  template: JST['application/templates/login_form']

  events:
    'click #login_submit': 'login'

  render: ->
    @$el.html(@template)

  login: =>
    @userName = "nope"
    @model.set(session: {
      user_name: $("#input_user_name").val()
      password: $("#input_password").val()
    })
    @model.save()
    .success (model, response, options) =>
      alert("success")
    .error (model, xhr, options) =>
      alert(JSON.parse(xhr.responseText).errors)
    Backbone.history.navigate("logged", { trigger: true })
