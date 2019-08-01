class App.Views.Home.IndexView extends App.View

  welcome_template: JST['application/templates/welcome']
  signup_template: JST['application/templates/signup_form']

  events:
    'click #signup': 'go_to_form'
    'click #submit': 'signup'

  initialize: ->
    @current_template = @welcome_template

  render: ->
    @$el.empty()
    @$el.append(@current_template)

  signup: ->
    @model.set(user: {
      user_name: $("#input_user_name").val()
      password: $("#input_password").val()
      password_confirmation: $("#input_password_confirmation").val()
    })
    @model.save()
    @current_template = @welcome_template

  go_to_form: ->
    @current_template = @signup_template
    @$el.empty()
    @$el.append(@current_template)