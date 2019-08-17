class App.Views.GoToNewFolderFormButton extends App.View

  template: JST['application/templates/folders/go_to_new_folder_form_button']

  events:
    'click #new_folder_form': 'goToNewFolderForm'

  render: ->
    @$el.html(@template)
    this

  goToNewFolderForm: ->
    this.trigger("new:folder:form:button")