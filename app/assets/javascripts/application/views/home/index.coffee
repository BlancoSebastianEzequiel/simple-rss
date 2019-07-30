class App.Views.Home.Index extends App.View
  render: ->
    @$el.empty()
    @$el.append(@model.get('notes'))