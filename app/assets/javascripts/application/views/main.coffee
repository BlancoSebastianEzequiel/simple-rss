class App.Views.Main extends App.View

  template: JST['application/templates/main']

  events:
    'click #signup': 'goToSignUpForm'
    'click #login': 'goToLoginForm'

  render: ->
    @$el.html(@template)
    if App.Sessions.isLogged()
      loggedNavBar = new App.Views.LoggedNavBar
      @$el.find("#nav_bar").html(loggedNavBar.render().el)
      logout = new App.Views.Logout(model: new App.Models.Session)
      @$el.find("#logout_button").html(logout.render().el)
    else
      guestNavBar = new App.Views.GuestNavBar
      @$el.find("#nav_bar").html(guestNavBar.render().el)
    this

  goToSignUpForm: ->
    signup = new App.Views.Signup(model: new App.Models.Signup)
    @$el.find("#body").html(signup.render().el)

  goToLoginForm: ->
    login = new App.Views.Login(model: new App.Models.Session)
    @$el.find("#body").html(login.render().el)

  append: (view) ->
    @$el.find("#body").html(view.render().el)
