App =
  source: $('meta[name=source]').attr("content")

  Models: {}
  Collections: {}
  Routers: {}
  Views: {}

  Utils:
    startLoad: ->
      $("#loading").show()

    stopLoad: ->
      $("#loading").hide()

    removeFrame: ->
      $('#frame').remove()

    shouldLoadApplication: ->
      !/view/g.test(window.location.pathname)

    attachView: (view) ->
      view.setElement("##{view.model.get('slug')}")

    indicateImageLoad: (view) ->
      App.Utils.startLoad()

      view.$('img').imagesLoaded ->
        App.Utils.stopLoad()

  initialize: ->
    @mediator = new App.Mediator
    @shortcuts = new App.Shortcuts
    @router = new App.Routers.Router

    Backbone.history.start({ pushState: true })


class App.Mediator
  _.extend @prototype, Backbone.Events


class App.Shortcuts extends Backbone.Shortcuts
  shortcuts:
    "esc" : "return"
  
  return: ->
    App.mediator.trigger 'block:return'


class App.Models.Object extends Backbone.Model
  fetch: ->
    App.Utils.startLoad()
    
    $.ajax
      url: "#{@get('href')}"
      success: (response) =>
        App.Utils.stopLoad()

        @set { fragment: response }


class App.Views.ChannelView extends Backbone.View
  events:
    'click .block': 'showBlock'
    'click .channel': 'loadChannel'

  showBlock: (e) ->
    e.preventDefault()

    App.router.navigate($(e.currentTarget).data('href'), { trigger: true })

  deactivateChannels: ->
    $('.contents').removeClass('active')

  scrollToChannel: (channel) ->
    $('html, body').animate { scrollTop: ($("##{channel.get('slug')}").offset().top - 20) }, 'fast'

  loadChannel: (e) ->
    $target = $(e.currentTarget)
    
    channel = new App.Models.Object(href: $target.data('href'), slug: $target.data('slug'))

    @deactivateChannels()

    $.when(channel.fetch()).then =>
      $target.after(channel.get('fragment')).remove()

      @scrollToChannel(channel)


class App.Views.BlockView extends Backbone.View
  id: 'frame'
  className: 'frame'
  events:
    'click .return': 'return'

  initialize: ->
    @listenTo(App.mediator, 'block:return', @return)
    @listenTo(App.mediator, 'block:remove', @remove)

  return: (e) ->
    e?.preventDefault()

    @remove()

    window.history.back()

  render: ->
    @$el.html @model.get('fragment')


class App.Routers.Router extends Backbone.Router
  routes:
    '': 'channel'
    ':channel': 'channel'
    'view/:block': 'block'

  initialize: ->
    @channel($('.wrapper').first().attr('id'))

  channel: (id) ->
    App.mediator.trigger 'block:remove'

    if id
      @channel = new App.Models.Object(slug: id)
      @view = new App.Views.ChannelView(model: @channel)

      App.Utils.attachView(@view)

  block: (path) ->
    block = new App.Models.Object(href: path)

    $.when(block.fetch()).then =>
      @view = new App.Views.BlockView(model: block)

      $('body').prepend(@view.render())

      App.Utils.indicateImageLoad(@view)


$ -> App.initialize() if App.Utils.shouldLoadApplication()
