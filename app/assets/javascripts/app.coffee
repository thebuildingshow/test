App =
  source: $("meta[name=source]").attr("content")

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
      $("#frame").remove()

    shouldLoadApplication: ->
      !/view/g.test(window.location.pathname)

    hasQueryString: (string) ->
      /\?/g.test(string)

    attachView: (view) ->
      view.setElement("##{view.model.get('slug')}")

    indicateImageLoad: (view) ->
      App.Utils.startLoad()

      view.$("img").imagesLoaded ->
        App.Utils.stopLoad()

  initialize: ->
    @mediator  = new App.Mediator
    @shortcuts = new App.Shortcuts
    @router    = new App.Routers.Router

    Backbone.history.start({ pushState: true })


class App.Mediator
  _.extend @prototype, Backbone.Events


class App.Shortcuts extends Backbone.Shortcuts
  shortcuts:
    "esc"   : "return"
    "i"     : "invert"
    "right" : "next"
    "left"  : "prev"
  
  return: ->
    App.mediator.trigger "block:return"

  invert: ->
    $("body").toggleClass("inverse")

  next: ->
    App.mediator.trigger "block:move", "next"

  prev: ->
    App.mediator.trigger "block:move", "prev"


class App.Models.Connectable extends Backbone.Model
  url: -> @get("url")

  fetch: (options) ->
    App.Utils.startLoad()
    
    $.ajax
      url: @get("url")

      success: (response) =>
        App.Utils.stopLoad()

        @set { fragment: response }
      
      error: (response) =>
        App.Utils.stopLoad()


class App.Models.Channel extends App.Models.Connectable


class App.Models.Block extends App.Models.Connectable
  initialize: ->
    @setAttributes() if App.Utils.hasQueryString(@get("url"))

  move: (direction="next") ->
    $("##{@get('via')}_#{@get(direction)}").attr("href")

  setAttributes: ->
    queryString = @get("url").split("?")[1].split("&")

    @set(pair[0], pair[1]) for pair in (pairs.split("=") for pairs in queryString)


class App.Views.ChannelView extends Backbone.View
  events:
    "click .block"   : "showBlock"
    "click .channel" : "loadChannel"

  showBlock: (e) ->
    e.preventDefault()

    App.router.navigate($(e.currentTarget).attr("href"), { trigger: true })

  deactivateChannels: ->
    $(".contents").removeClass("active")

  scrollToChannel: (channel) ->
    $("html, body").animate { scrollTop: ($("##{channel.get('slug')}").offset().top - 20) }, "fast"

  loadChannel: (e) ->
    e.preventDefault()
    
    $target = $(e.currentTarget)
    
    channel = new App.Models.Channel(url: $target.attr("href"), slug: $target.data("slug"))

    @deactivateChannels()

    $.when(channel.fetch()).then =>
      $target.after(channel.get("fragment")).remove()

      @scrollToChannel(channel)


class App.Views.BlockView extends Backbone.View
  id: "frame"
  className: "frame"
  events:
    "click .return": "return"

  initialize: ->
    @listenTo App.mediator, "block:move", @move
    @listenTo App.mediator, "block:return", @return
    @listenTo App.mediator, "block:remove", @remove

  return: (e) ->
    e?.preventDefault()

    via = $("##{@model.get('via')}").attr("href")

    App.router.navigate(via, { trigger: true })

  remove: ->
    super
    
    App.Utils.stopLoad()

  move: (direction) ->
    App.router.navigate(@model.move(direction), { trigger: true })

  render: ->
    @$el.html @model.get("fragment")


class App.Routers.Router extends Backbone.Router
  routes:
    ""            : "channel"
    ":channel"    : "channel"
    "view/:block" : "block"

  initialize: ->
    @channel($(".wrapper").first().attr("id"))

  channel: (id) ->
    App.mediator.trigger "block:remove"

    if id
      @channel = new App.Models.Channel(slug: id)
      @view    = new App.Views.ChannelView(model: @channel)

      App.Utils.attachView(@view)

  block: (path) ->
    App.mediator.trigger "block:remove"

    block = new App.Models.Block(url: path)

    $.when(block.fetch()).then =>
      @lightbox = new App.Views.BlockView(model: block)

      $("body").prepend(@lightbox.render())

      App.Utils.indicateImageLoad(@lightbox)


$ -> App.initialize() if App.Utils.shouldLoadApplication()
