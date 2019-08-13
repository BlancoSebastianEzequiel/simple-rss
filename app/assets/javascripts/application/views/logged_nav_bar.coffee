class App.Views.LoggedNavBar extends App.View

  template: JST['application/templates/logged_nav_bar']

  render: ->
    @$el.html(@template)
    this