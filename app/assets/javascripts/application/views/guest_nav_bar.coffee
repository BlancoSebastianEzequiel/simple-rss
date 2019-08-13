class App.Views.GuestNavBar extends App.View

  template: JST['application/templates/guest_nav_bar']

  render: ->
    @$el.html(@template)
    this
