{-# LANGUAGE OverloadedStrings #-}
module Brick.Border
  ( border
  , borderWithLabel

  , hBorder
  , hBorderWithLabel
  , vBorder

  , borderAttr
  , vBorderAttr
  , hBorderAttr
  , hBorderLabelAttr
  , tlCornerAttr
  , trCornerAttr
  , blCornerAttr
  , brCornerAttr
  )
where

import Data.Monoid ((<>))

import Brick.Widgets.Core
import Brick.AttrMap
import Brick.Center (hCenterWith)
import Brick.Border.Style (BorderStyle(..))

borderAttr :: AttrName
borderAttr = "border"

vBorderAttr :: AttrName
vBorderAttr = borderAttr <> "vertical"

hBorderAttr :: AttrName
hBorderAttr = borderAttr <> "horizontal"

hBorderLabelAttr :: AttrName
hBorderLabelAttr = hBorderAttr <> "label"

tlCornerAttr :: AttrName
tlCornerAttr = borderAttr <> "corner" <> "tl"

trCornerAttr :: AttrName
trCornerAttr = borderAttr <> "corner" <> "tr"

blCornerAttr :: AttrName
blCornerAttr = borderAttr <> "corner" <> "bl"

brCornerAttr :: AttrName
brCornerAttr = borderAttr <> "corner" <> "br"

border :: Widget -> Widget
border = border_ Nothing

borderWithLabel :: Widget -> Widget -> Widget
borderWithLabel label = border_ (Just label)

border_ :: Maybe Widget -> Widget -> Widget
border_ label wrapped =
    Widget $ do
      bs <- getActiveBorderStyle
      let top = (withAttrName tlCornerAttr $ str [bsCornerTL bs])
                <<+ hBorder_ label +>>
                (withAttrName trCornerAttr $ str [bsCornerTR bs])
          bottom = (withAttrName blCornerAttr $ str [bsCornerBL bs])
                   <<+ hBorder +>>
                   (withAttrName brCornerAttr $ str [bsCornerBR bs])
          middle = vBorder +>> wrapped <<+ vBorder
          total = top =>> middle <<= bottom
      render total

hBorder :: Widget
hBorder = hBorder_ Nothing

hBorderWithLabel :: Widget -> Widget
hBorderWithLabel label = hBorder_ (Just label)

hBorder_ :: Maybe Widget -> Widget
hBorder_ label =
    Widget $ do
      bs <- getActiveBorderStyle
      render $ withAttrName hBorderAttr $ hCenterWith (Just $ bsHorizontal bs) msg
      where
          msg = maybe (txt "") (withAttrName hBorderLabelAttr) label

vBorder :: Widget
vBorder =
    Widget $ do
      bs <- getActiveBorderStyle
      render $ withAttrName vBorderAttr $ vFill (bsVertical bs)
