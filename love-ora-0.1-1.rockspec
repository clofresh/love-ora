 package = "love-ora"
 version = "0.1-1"
 source = {
    url = "https://github.com/clofresh/love-ora/archive/v0.1.zip",
    md5 = "d95d4c03794f6340cb60e920d0c8b203",
    dir = "love-ora-0.1"
 }
 description = {
    summary = "A library for loading OpenRaster files into LÖVE games.",
    detailed = [[
      Having a direct export of a level you've set up in GIMP directly into LÖVE
      makes it much easier to iterate over your work. Tiled offers a similar
      workflow for tile-based games, but I couldn't find anything for setting up
      arbitrary images. Since I was already creating and laying out the level
      images in GIMP, and GIMP had such a flexible plugin system, I figured it
      would be a perfect level editor, reducing the steps to get art and level
      asserts into the game and improving the iteration feedback loop.
]],
    homepage = "https://github.com/clofresh/love-ora",
    license = "BSD"
 }
 dependencies = {
    "lua = 5.1",
    "xml ~> 1.1"
 }
build = {
  type = 'builtin',
  modules = {
    ['ora'] = 'ora.lua'
  }
}
