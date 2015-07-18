module Main where

import qualified Graphics.UI.SDL as SDL
import qualified Graphics.UI.SDL.Image as Image
import Graphics.UI.SDL.Types
import Shared.Assets
import Shared.Input
import Shared.Lifecycle
import Shared.Polling
import Shared.Utils


title :: String
title = "lesson07"

size :: ScreenSize
size = (640, 480)

inWindow :: (SDL.Window -> IO ()) -> IO ()
inWindow = withSDL . withWindow title size

fullWindow :: SDL.Rect
fullWindow = SDL.Rect {
    rectX = 0,
    rectY = 0,
    rectW = fst size,
    rectH = snd size }

main :: IO ()
main = inWindow $ \window -> Image.withImgInit [Image.InitPNG] $ do
    setHint "SDL_RENDER_SCALE_QUALITY" "1" >>= logWarning
    renderer <- createRenderer window (-1) [SDL.SDL_RENDERER_ACCELERATED] >>= either throwSDLError return
    SDL.setRenderDrawColor renderer 0xFF 0xFF 0xFF 0xFF
    texture <- Image.imgLoadTexture renderer "./assets/texture.png" >>= either throwSDLError return
    repeatUntilTrue $ draw renderer texture >> handleNoInput pollEvent
    SDL.destroyTexture texture
    SDL.destroyRenderer renderer

draw :: SDL.Renderer -> SDL.Texture -> IO ()
draw renderer texture = do
    SDL.renderClear renderer
    SDL.renderCopy renderer texture nullPtr nullPtr
    SDL.renderPresent renderer

