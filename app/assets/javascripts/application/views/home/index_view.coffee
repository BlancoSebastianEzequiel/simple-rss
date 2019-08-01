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
    @model.save()
    @current_template = @welcome_template
    @$el.empty()
    @$el.append(@current_template)

  signup: ->
    @model.set(user: {
      user_name: $("#input_user_name").val()
      password: $("#input_password").val()
      password_confirmation: $("#input_password_confirmation").val()
    })
    @model.save()
    @current_template = @login_template
    @$el.empty()
    @$el.append(@current_template)

  go_to_signup_form: ->
    @current_template = @signup_template
    @$el.empty()
    @$el.append(@current_template)

  go_to_login_form: ->
    @current_template = @login_template
    @$el.empty()
    @$el.append(@current_template)