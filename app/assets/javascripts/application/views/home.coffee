class App.Views.Home extends App.View

  template: JST['application/templates/welcome']

  events:
    'click #signup': 'go_to_signup_form'
    'click #login': 'go_to_login_form'

  render: ->
    @$el.html(@template())

  go_to_signup_form: ->
    Backbone.history.navigate("signup", { trigger: true })

  go_to_login_form: ->
    Backbone.history.navigate("login", { trigger: true })