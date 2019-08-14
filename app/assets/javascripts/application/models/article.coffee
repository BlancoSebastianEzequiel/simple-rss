class App.Models.Article extends App.Model
  urlRoot: "/articles"
  defaults:
    link: ""
    title: ""
    avatar: "https://abeon-hosting.com/images/no-avatar-png-7.png"
    description: ""

  getLink: ->
    this.get("article").link

  getTitle: ->
    this.get("article").title

  getDescription: ->
    this.get("article").description

  getAvatar: ->
    this.get("article").avatar || this.get("avatar")

  getReadValue: ->
    this.get("read")
