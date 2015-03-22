# Flower Tiled
A library for using Tiled Map Editor.(Support Version: 0.9.0)

http://www.mapeditor.org/

## Usage
It is the simplest way.

```Lua
tiled = require "flower.tiled"

function onCreate(e)
    layer = flower.Layer()
    layer:setScene(scene)
    layer:setSortMode(MOAILayer.SORT_PRIORITY_ASCENDING)
    
    tileMap = tiled.TileMap()
    tileMap:loadLueFile("platform.lue")
    tileMap:setLayer(layer)
end
```

## Isometric
It is possible to use Isometric.

## Performance
Designed to reduce the drawing.

When using a single tileset, and perform only once drawn.

## Scalability
Design for easy expansion.

Easy to inherited class, switching is simple.

