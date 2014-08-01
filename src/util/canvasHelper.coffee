drawImage = (image, target, param) ->
  param = {}  unless param
  xFrom = (if param.xFrom isnt `undefined` then param.xFrom else 0)
  yFrom = (if param.yFrom isnt `undefined` then param.yFrom else 0)
  xFromSize = (if param.xFromSize isnt `undefined` then param.xFromSize else (image.naturalWidth or image.width))
  yFromSize = (if param.yFromSize isnt `undefined` then param.yFromSize else (image.naturalHeight or image.height))
  xTo = (if param.xTo isnt `undefined` then param.xTo else 0)
  yTo = (if param.yTo isnt `undefined` then param.yTo else 0)
  xToSize = (if param.xToSize isnt `undefined` then param.xToSize else xFromSize)
  yToSize = (if param.yToSize isnt `undefined` then param.yToSize else yFromSize)
  xPaintArea = (if param.xPaintArea isnt `undefined` then param.xPaintArea else xToSize)
  yPaintArea = (if param.yPaintArea isnt `undefined` then param.yPaintArea else yToSize)
  xAlign = (if param.xAlign isnt `undefined` then param.xAlign else "middle")
  yAlign = (if param.yAlign isnt `undefined` then param.yAlign else "middle")
  xRotateCenter = (if param.xRotateCenter isnt `undefined` then param.xRotateCenter else "middle")
  yRotateCenter = (if param.yRotateCenter isnt `undefined` then param.yRotateCenter else "middle")
  rotate = (if param.rotate isnt `undefined` then param.rotate else 0)
  if typeof xAlign isnt "number"
    switch xAlign
      when "left"
        xAlign = 0
      when "middle"
        xAlign = (xPaintArea - xToSize) / 2
      when "right"
        xAlign = xPaintArea - xToSize
      else
        throw new Error("unknown xAlign : " + xAlign)
  if typeof yAlign isnt "number"
    switch yAlign
      when "up"
        yAlign = 0
      when "middle"
        yAlign = (yPaintArea - yToSize) / 2
      when "down"
        yAlign = yPaintArea - yToSize
      else
        throw new Error("unknown yAlign : " + yAlign)
  if typeof xRotateCenter isnt "number"
    switch xRotateCenter
      when "up"
        xRotateCenter = 0
      when "middle"
        xRotateCenter = xToSize / 2
      when "down"
        xRotateCenter = xToSize
      else
        throw new Error("unknown xRotateCenter : " + xRotateCenter)
  if typeof yRotateCenter isnt "number"
    switch yRotateCenter
      when "up"
        yRotateCenter = 0
      when "middle"
        yRotateCenter = yToSize / 2
      when "down"
        yRotateCenter = yToSize
      else
        throw new Error("unknown yRotateCenter : " + yRotateCenter)
  xRealShift = xTo + xAlign
  yRealShift = yTo + yAlign
  xRotateCenter = xRealShift + xRotateCenter
  yRotateCenter = yRealShift + yRotateCenter
  if rotate is 0
    target.drawImage image, xFrom, yFrom, xFromSize, yFromSize, xRealShift, yRealShift, xToSize, yToSize
  else
    target.save()
    target.transform 1, 0, 0, 1, xRotateCenter, yRotateCenter
    target.rotate rotate
    target.transform 1, 0, 0, 1, -xRotateCenter, -yRotateCenter
    target.drawImage image, xFrom, yFrom, xFromSize, yFromSize, xRealShift, yRealShift, xToSize, yToSize
    target.restore()
  true
module.exports =
  drawImage : drawImage