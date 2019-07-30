class App.Views.Home.IndexView extends App.View
  render: ->
    @$el.empty()
    @$el.append(@model.get('notes'))