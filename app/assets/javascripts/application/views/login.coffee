class App.Views.Login extends App.View

  template: JST['application/templates/login_form']

  events:
    'click #login_submit': 'login'

  render: ->
    @$el.html(@template)
    this

  login: =>
    @model.set(user_name: $("#input_user_name").val())
    @model.set(password: $("#input_password").val())
    @model.save()
    .success (model, response, options) =>
      alert("success")
      this.model.set("id", model.id)
      Backbone.history.navigate("logged", { trigger: true })
    .error (error) =>
      alert(JSON.stringify(JSON.parse(error.responseText).errors))
