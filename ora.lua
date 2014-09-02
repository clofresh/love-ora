local Xml = require('xml')

local module = {}

local function processAttrs(node)
    local attrs = {}
    for key, valStr in pairs(node.xarg) do
        local num = tonumber(valStr)
        if num then
            attrs[key] = num
        else
            local vals = {}
            for val in valStr:gmatch('[^,]+') do
                table.insert(vals, tonumber(val) or val)
            end
            if #vals == 1 then
                attrs[key] = vals[1]
            else
                attrs[key] = vals
            end
        end
    end
    return attrs
end

local function processLayers(ora, node, filepath)
    local layers = {}
    for i, layerData in ipairs(node) do
        local layer = processAttrs(layerData)
        layer.image = love.graphics.newImage(filepath .. '/' .. layer.src)
        table.insert(layers, layer)
    end
    ora.layers = layers
    return layers
end

local function processPaths(ora, node, filepath)
    local paths = {}
    for i, pathData in ipairs(node) do
        local path = processAttrs(pathData)

        local contents, size = love.filesystem.read(filepath .. '/' .. path.src)
        local name, vertices
        vertices = {}
        local rowNum = 1
        for row in contents:gmatch('[^\n]+') do
            local x, y
            local colNum = 1
            for col in row:gmatch('[^,]+') do
                if colNum == 1 then
                    name = col
                elseif colNum == 5 then
                    x = tonumber(col)
                elseif colNum == 6 then
                    y = tonumber(col)
                end
                colNum = colNum + 1
            end
            if name ~= nil then
                assert(x)
                assert(y)
                table.insert(vertices, x)
                table.insert(vertices, y)
            end
            rowNum = rowNum + 1
        end
        if #vertices > 2 and vertices[1] == vertices[#vertices-1] and vertices[2] == vertices[#vertices] then
            table.remove(vertices)
            table.remove(vertices)
        end
        path.vertices = vertices

        table.insert(paths, path)
    end
    ora.paths = paths
    return paths
end

function module.load(filepath)
    -- Read the metadata file as xml
    local stackPath = filepath .. '/stack.xml'
    local contents, size = love.filesystem.read(stackPath)
    local data = Xml.string_to_table(contents)

    -- Find the root node
    local root
    for i, node in ipairs(data) do
        if node.label == 'image' then
            root = node
            break
        end
    end
    assert(root, 'No root <image> tag found in ' .. stackPath)

    -- Instantiate the object
    local self = {
        x = 0,
        y = 0,
        w = tonumber(root.xarg.w),
        h = tonumber(root.xarg.h),
        layers = nil,
        paths = nil,
    }

    -- Parse the child nodes
    local processors = {
        stack = processLayers,
        paths = processPaths,
    }
    for i, node in ipairs(root) do
        local processor = processors[node.label]
        if processor then
            processor(self, node, filepath)
        end
    end

    return self
end

return module
