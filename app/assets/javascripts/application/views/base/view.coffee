class App.View extends Backbone.View
  validated: (button, valid) ->
    return if not button
    if valid
      button.attr("disabled", false)
    else
      button.attr("disabled", true)
_.extend App.View, App.Mixins