class App.View extends Backbone.View
  toggleEnabled: (button, valid) ->
    if valid
      button.attr("disabled", false)
    else
      button.attr("disabled", true)
_.extend App.View, App.Mixins