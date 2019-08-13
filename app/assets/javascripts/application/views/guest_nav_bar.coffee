class App.Views.GuestNavBar extends App.View

  template: JST['application/templates/guest_nav_bar']

  events:
    'click #signup': 'go_to_signup_form'
    'click #login': 'go_to_login_form'

  render: ->
    @$el.html(@template)
    this

  go_to_signup_form: ->
    signup = new App.Views.Signup(model: new App.Models.Signup)
    @$el.find("#form").html(signup.render().el)

  go_to_login_form: ->
    login = new App.Views.Login(model: new App.Models.Session)
    @$el.find("#form").html(login.render().el)