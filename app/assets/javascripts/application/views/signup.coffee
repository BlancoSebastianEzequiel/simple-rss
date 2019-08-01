class App.Views.Signup extends App.View

  template: JST['application/templates/signup_form']

  events:
    'click #signup_submit': 'signup'

  render: ->
    @$el.html(@template)

  signup: ->
    console.log("here")
    @model.set(user: {
      user_name: $("#input_user_name").val()
      password: $("#input_password").val()
      password_confirmation: $("#input_password_confirmation").val()
    })
    @model.save()
    .success (res) ->
      alert("success signup")
    .error (error) ->
      alert(JSON.stringify(error.responseText))
    Backbone.history.navigate("login", { trigger: true })
