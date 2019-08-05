class App.Views.Signup extends App.View

  template: JST['application/templates/signup_form']

  events:
    'click #signup_submit': 'signup'

  render: ->
    @$el.html(@template)
    this

  signup: =>
    @model.set(user_name: $("#input_user_name").val())
    @model.set(password: $("#input_password").val())
    @model.set(password_confirmation: $("#input_password_confirmation").val())
    @model.save()
    .success (model, response, options) =>
      alert("success signup")
      Backbone.history.loadUrl("login", { trigger: true })
    .error (error) =>
      alert(JSON.stringify(JSON.parse(error.responseText).errors))
