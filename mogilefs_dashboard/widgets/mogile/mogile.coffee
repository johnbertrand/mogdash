class Dashing.Mogile extends Dashing.Widget

  pad = (val, length, padChar = '0') ->
    val += ''
    numPads = length - val.length
    if (numPads > 0) then new Array(numPads + 1).join(padChar) + val else val


  @accessor 'current', ->
    return @get('displayedValue') if @get('displayedValue')
    points = @get('points')
    if points
      points[points.length - 1].y


  @accessor 'currentfs1', ->
    points = @get('fs1')
    if points
      "FS1: " + points[points.length - 1].y


  @accessor 'currentfs2', ->
    points = @get('fs2')
    if points
     "FS2: " + points[points.length - 1].y

  @accessor 'currentfs3', ->
    points = @get('fs3')
    if points
      "FS3: " + points[points.length - 1].y



  ready: ->
    container = $(@node).parent()
    # Gross hacks. Let's fix this.
    width  = (Dashing.widget_base_dimensions[0] * container.data("sizex")) + Dashing.widget_margins[0] * 2 * (container.data("sizex") - 1)
    height = (Dashing.widget_base_dimensions[1] * container.data("sizey"))

    palette = new Rickshaw.Color.Palette ( { scheme: 'colorwheel' } )

    @graph = new Rickshaw.Graph(
      element: @node
      width: width
      height: height
      renderer: "line"
      series: [
        {
          color: palette.color(),
          data: [{x:0, y:0}]
        },{
          color: palette.color(),
          data: [{x:0, y:0}]
        },{
          color: palette.color(),
          data: [{x:0, y:0}]
        }
      ]
    )

    @graph.series[0].data = @get('fs1') if @get('fs1')
    @graph.series[1].data = @get('fs2') if @get('fs2')
    @graph.series[2].data = @get('fs3') if @get('fs3')

    x_axis = new Rickshaw.Graph.Axis.Time(graph: @graph)
    y_axis = new Rickshaw.Graph.Axis.Y(graph: @graph, tickFormat: Rickshaw.Fixtures.Number.formatKMBT)
    @graph.render()

  onData: (data) ->
    if @graph
      @graph.series[0].data = data.fs1
      @graph.series[1].data = data.fs2
      @graph.series[2].data = data.fs3
      @graph.render()
