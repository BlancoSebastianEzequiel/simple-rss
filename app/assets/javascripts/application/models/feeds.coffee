class App.Models.Feed extends App.Model
  urlRoot: "/feeds"
  defaults:
    url: ""
    title: ""

  isSelected: ->
    this.get("select")
