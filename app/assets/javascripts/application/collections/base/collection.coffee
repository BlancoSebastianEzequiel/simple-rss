class App.Collection extends Backbone.Collection
  sync: (method, collection, options) =>
    options = options || {}
    options.beforeSend = (xhr) ->
      xhr.setRequestHeader('Authorization', localStorage.getItem("auth_token"))
    Backbone.Model.prototype.sync.apply(this, arguments)
_.extend App.Collection, App.Mixins