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

  autoLogin: (userName, password)->
    login = new App.Views.Login(model: new App.Models.Session { user_name: userName, password: password })
    login.login()

  setErrors: ->
    errors = @model.get("errors")
    if errors
      userNameError = errors.user_name
      passwordError = errors.password || ""
      passwordConfirmationError = errors.password_confirmation || ""
      @$el.find("#user_name_error").text(userNameError)
      @$el.find("#password_error").text(passwordError)
      @$el.find("#password_confirmation_error").text(passwordConfirmationError)

  signup: =>
    this.toggleEnabled(@signupButton, false)
    @model.set(user_name: $("#input_user_name").val())
    @model.set(password: $("#input_password").val())
    @model.set(password_confirmation: $("#input_password_confirmation").val())
    @model.save()
    .success (model, response, options) =>
      this.toggleEnabled(@signupButton, true)
      this.autoLogin(@model.get("user_name"), @model.get("password"))
    .error (error) =>
      @model.set(errors: JSON.parse(error.responseText).errors)
      this.toggleEnabled(@signupButton, true)
      this.setErrors()
