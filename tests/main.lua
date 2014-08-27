package.path = package.path .. ";../?.lua"

local Ora = require('ora')

function assertEquals(actual, expected, msg)
    assert(actual == expected, string.format('%s (%s != %s)', msg, actual or 'nil', expected or 'nil'))
end

function love.load()
    assert(Ora, 'Could not load Ora module')
    ora = Ora.load('test-cases')
    assert(ora, 'Could not initialize Ora object')
    assertEquals(ora.w, 16, 'Incorrect image width')
    assertEquals(ora.h, 16, 'Incorrect image height')
    assertEquals(#ora.layers, 4, 'Incorrect number of layers')

    local layer
    layer = ora.layers[1]
    assertEquals(layer.name, '1-normal-name', 'Incorrect name')
    assertEquals(layer.x, 5, 'Invalid x')
    assertEquals(layer.y, 4, 'Invalid y')

    layer = ora.layers[2]
    assertEquals(layer.name, '2-single-attr', 'Incorrect name')
    assertEquals(layer.myattr, 1, 'Incorrect attr: myattr')
    assertEquals(layer.x, 4, 'Invalid x')
    assertEquals(layer.y, 4, 'Invalid y')

    layer = ora.layers[3]
    assertEquals(layer.name, '3-many-attr', 'Incorrect name')
    assertEquals(layer.foo, 'a', 'Incorrect attr: foo')
    assertEquals(layer.bar, 'b', 'Incorrect attr: bar')
    assertEquals(layer.baz, 'c', 'Incorrect attr: baz')
    assertEquals(layer.x, 5, 'Invalid x')
    assertEquals(layer.y, 4, 'Invalid y')

    layer = ora.layers[4]
    assertEquals(layer.name, '4-repeated-attrs', 'Incorrect name')
    assertEquals(layer.expected, 3, 'Incorrect attr: expected')
    assertEquals(#layer.stuff, tonumber(layer.expected), 'Wrong size of stuff attr')
    assertEquals(layer.stuff[1], 3, 'Incorrect #1 val of stuff')
    assertEquals(layer.stuff[2], 2, 'Incorrect #2 val of stuff')
    assertEquals(layer.stuff[3], 1, 'Incorrect #3 val of stuff')
    assertEquals(layer.x, 5, 'Invalid x')
    assertEquals(layer.y, 5, 'Invalid y')

    assertEquals(#ora.paths, 4, 'Incorrect number of paths')

    local path
    path = ora.paths[1]
    assertEquals(path.name, '2-normal-name', 'Incorrect name')
    assertEquals(#path.vertices, 2*2, 'Incorrect number of vertices')

    path = ora.paths[2]
    assertEquals(path.name, '3-single-attr', 'Incorrect name')
    assertEquals(#path.vertices, 3*2, 'Incorrect number of vertices')
    assertEquals(path.p, 'q', 'Incorrect attr: p')

    path = ora.paths[3]
    assertEquals(path.name, '4-many-attr', 'Incorrect name')
    assertEquals(#path.vertices, 4*2, 'Incorrect number of vertices')
    assertEquals(path.a, 'z', 'Incorrect attr: a')
    assertEquals(path.b, 'y', 'Incorrect attr: b')
    assertEquals(path.c, 'x', 'Incorrect attr: b')

    path = ora.paths[4]
    assertEquals(path.name, '5-repeated-attrs', 'Incorrect name')
    assertEquals(#path.vertices, 5*2, 'Incorrect number of vertices')
    assertEquals(path.expected, 3, 'Incorrect attr: expected')
    assertEquals(path.vals[1], 'q', 'Incorrect #1 val of vals')
    assertEquals(path.vals[2], 'w', 'Incorrect #2 val of vals')
    assertEquals(path.vals[3], 'e', 'Incorrect #3 val of vals')

    love.window.setMode(ora.w * (#ora.layers + 1), ora.h * 3)
end

function love.draw()
    love.graphics.setBackgroundColor(255, 255, 255)
    local startX = ora.w / 2
    local startY = ora.h / 2
    for i, layer in pairs(ora.layers) do
        love.graphics.draw(layer.image, startX + layer.x, startY + layer.y)
        startX = startX + ora.w
    end
    love.graphics.setColor(0, 255, 0)
    startX = ora.w / 2
    startY = ora.h * 1.5
    for i, path in pairs(ora.paths) do
        love.graphics.push()
        love.graphics.translate(startX, startY)
        if #path.vertices == 4 then
            love.graphics.line(path.vertices)
        else
            love.graphics.polygon('line', path.vertices)
        end
        startX = startX + ora.w
        love.graphics.pop()
    end

end