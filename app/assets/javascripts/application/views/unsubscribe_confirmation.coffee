class App.Views.UnsubscribeConfirmation extends App.View

  template: JST['application/templates/unsubscribe_confirmation']

  events:
    'click #confirm': 'confirm'
    'click #cancel': 'cancel'

  render: ->
    @$el.html(@template)
    modal = @$el.find("#unsubscribe_confirmation")
    @$el.find('.modal').modal()
    @$el.find('#unsubscribe_confirmation').modal('open')
    @$el.find('.trigger-modal').modal();
    this

  confirm: ->
    this.trigger("confirm:unsubscribe")

  cancel: ->
    this.trigger("cancel:unsubscribe")
