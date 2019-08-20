class App.Views.GoToUserFoldersListButton extends App.View

  template: JST['application/templates/folders/go_to_user_folders_list_button']

  events:
    'click #user_folders_list': 'goToUserFolders'

  render: ->
    @$el.html(@template)
    this

  goToUserFolders: ->
    this.trigger("user:folder:button")
