class App.Views.Signup extends App.View

  template: JST['application/templates/signup_form']

  events:
    'click #signup_submit': 'signup'

  render: ->
    errors = @model.get("errors")
    userNameError = errors.user_name if errors
    passwordError = errors.password if errors
    passwordConfirmationError = errors.password_confirmation if errors
    @$el.html(@template({ userNameError, passwordError, passwordConfirmationError }))
    @signupButton = @$el.find("#signup_submit")
    this.toggleEnabled(@signupButton, true)
    this

  signup: =>
    this.toggleEnabled(@signupButton, false)
    @model.set(user_name: $("#input_user_name").val())
    @model.set(password: $("#input_password").val())
    @model.set(password_confirmation: $("#input_password_confirmation").val())
    @model.save()
    .success (model, response, options) =>
      alert("success signup")
      this.toggleEnabled(@signupButton, true)
      Backbone.history.navigate("login", { trigger: true })
    .error (error) =>
      @model.set(errors: JSON.parse(error.responseText).errors)
      this.render()
