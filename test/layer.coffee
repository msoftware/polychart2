module "Layer"
test "point", ->
  jsondata= [
    {x: 2, y: 4},
    {x: 3, y: 3}
  ]
  data = new poly.Data (json: jsondata)
  spec =
    layers: [
      data: data, type: 'point', x: 'x', y: 'y'
    ]
  layers = poly.chart spec
  layer = layers[0]

  equal layer.geoms.length, 2
  equal layer.geoms[0].geoms[0].type, 'point'
  equal layer.geoms[0].geoms[0].x, 2
  equal layer.geoms[0].geoms[0].y, 4
  deepEqual layer.geoms[0].geoms[0].color, poly.scaleFns.identity(layer.defaults.color)
  deepEqual layer.geoms[0].evtData.x.in, [2]
  deepEqual layer.geoms[0].evtData.y.in, [4]

  equal layer.geoms[1].geoms[0].type, 'point'
  equal layer.geoms[1].geoms[0].x, 3
  equal layer.geoms[1].geoms[0].y, 3
  deepEqual layer.geoms[1].geoms[0].color, poly.scaleFns.identity(layer.defaults.color)
  deepEqual layer.geoms[1].evtData.x.in, [3]
  deepEqual layer.geoms[1].evtData.y.in, [3]

test "lines", ->
  # single line
  jsondata= [
    {x: 2, y: 4},
    {x: 3, y: 3}
  ]
  data = new poly.Data (json: jsondata)
  spec =
    layers: [
      data: data, type: 'line', x: 'x', y: 'y'
    ]
  layers = poly.chart spec
  layer = layers[0]

  equal layer.geoms.length, 1
  equal layer.geoms[0].geoms[0].type, 'line'
  deepEqual layer.geoms[0].geoms[0].x, [2, 3]
  deepEqual layer.geoms[0].geoms[0].y, [4, 3]
  deepEqual layer.geoms[0].geoms[0].color, poly.scaleFns.identity(layer.defaults.color)
  deepEqual layer.geoms[0].evtData, {}

  # one grouping
  jsondata= [
    {x: 2, y: 4, z: 'A'}
    {x: 3, y: 3, z: 'A'}
    {x: 1, y: 4, z: 2}
    {x: 5, y: 3, z: 2}
  ]
  data = new poly.Data (json: jsondata)
  spec =
    layers: [
      data: data, type: 'line', x: 'x', y: 'y', color: 'z'
    ]
  layers = poly.chart spec
  layer = layers[0]

  equal layer.geoms.length, 2
  equal layer.geoms[0].geoms[0].type, 'line'
  deepEqual layer.geoms[0].geoms[0].x, [2, 3]
  deepEqual layer.geoms[0].geoms[0].y, [4, 3]
  deepEqual layer.geoms[0].geoms[0].color, 'A'
  deepEqual layer.geoms[0].evtData.z.in, ['A']
  deepEqual layer.geoms[1].geoms[0].x, [1, 5]
  deepEqual layer.geoms[1].geoms[0].y, [4, 3]
  deepEqual layer.geoms[1].geoms[0].color, 2
  deepEqual layer.geoms[1].evtData.z.in, [2]

test "bars", ->
  # single line
  jsondata= [
    {x: 'A', y: 4},
    {x: 'A', y: 3}
  ]
  data = new poly.Data (json: jsondata)
  spec =
    layers: [
      data: data, type: 'bar', x: 'x', y: 'y'
    ]
  layers = poly.chart spec
  layer = layers[0]
  equal layer.geoms.length, 2
  equal layer.geoms[0].geoms[0].type, 'rect'
  deepEqual layer.geoms[0].geoms[0].x1 , poly.scaleFns.lower 'A'
  deepEqual layer.geoms[0].geoms[0].x2 , poly.scaleFns.upper 'A'
  equal layer.geoms[0].geoms[0].y1 , 0
  equal layer.geoms[0].geoms[0].y2 , 4
  equal layer.geoms[1].geoms[0].type, 'rect'
  deepEqual layer.geoms[1].geoms[0].x1 , poly.scaleFns.lower 'A'
  deepEqual layer.geoms[1].geoms[0].x2 , poly.scaleFns.upper 'A'
  equal layer.geoms[1].geoms[0].y1 , 4
  equal layer.geoms[1].geoms[0].y2 , 7
