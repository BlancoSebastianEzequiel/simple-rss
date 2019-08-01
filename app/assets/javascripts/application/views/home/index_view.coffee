class App.Views.Home.IndexView extends App.View

  welcome_template: JST['application/templates/welcome']
  signup_template: JST['application/templates/signup_form']
  login_template: JST['application/templates/login_form']


  events:
    'click #signup': 'go_to_signup_form'
    'click #login': 'go_to_login_form'
    'click #signup_submit': 'signup'
    'click #login_submit': 'login'

  initialize: ->
    @current_template = @welcome_template

  render: ->
    @$el.empty()
    @$el.append(@current_template)

  login: ->
    @model.urlRoot = "/login"
    @model.set(session: {
      user_name: $("#input_user_name").val()
      password: $("#input_password").val()
    })
    @model.save().success (res) ->
        alert("success login")
      .error (error) ->
        alert("ERROR")
        alert(JSON.stringify(error.responseText))
    @current_template = @welcome_template
    this.render()


  signup: ->
    @model.urlRoot = "/signup"
    @model.set(user: {
      user_name: $("#input_user_name").val()
      password: $("#input_password").val()
      password_confirmation: $("#input_password_confirmation").val()
    })
    @model.save().success (res) ->
      alert("success signup")
    .error (error) ->
      alert(JSON.stringify(error.responseText))
    @current_template = @login_template
    this.render()

  go_to_signup_form: ->
    @current_template = @signup_template
    this.render()

  go_to_login_form: ->
    @current_template = @login_template
    this.render()