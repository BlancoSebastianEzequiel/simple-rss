class App.Models.Folder extends App.Model
  urlRoot: "/folders"
  defaults:
    name: ""

  getName: ->
    this.get("name")
