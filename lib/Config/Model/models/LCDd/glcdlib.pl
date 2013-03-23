#
# This file is part of Config-Model
#
# This software is Copyright (c) 2012 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
  {
    'class_description' => 'generated from LCDd.conf',
    'name' => 'LCDd::glcdlib',
    'element' => [
      'ShowDebugFrame',
      {
        'value_type' => 'uniline',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'turns on/off 1 pixel thick debugging'
      },
      'Invert',
      {
        'value_type' => 'uniline',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'invert light/dark pixels'
      },
      'CharEncoding',
      {
        'value_type' => 'uniline',
        'default' => 'iso8859-2',
        'type' => 'leaf',
        'description' => 'character encoding to use'
      },
      'Contrast',
      {
        'value_type' => 'uniline',
        'default' => '50',
        'type' => 'leaf',
        'description' => 'Contrast (in %) if applicable'
      },
      'UpsideDown',
      {
        'value_type' => 'uniline',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'flip image upside down'
      },
      'TextResolution',
      {
        'value_type' => 'uniline',
        'upstream_default' => '16x4',
        'type' => 'leaf',
        'description' => 'text resolution in fixed width characters 
(if it won\'t fit according to available physical pixel resolution
and the minimum available font face size in pixels, then
\'DebugBorder\' will automatically be turned on)'
      },
      'PixelShiftY',
      {
        'value_type' => 'uniline',
        'default' => '2',
        'type' => 'leaf'
      },
      'Brightness',
      {
        'value_type' => 'uniline',
        'default' => '50',
        'type' => 'leaf',
        'description' => 'Brightness (in %) if applicable'
      },
      'PixelShiftX',
      {
        'value_type' => 'uniline',
        'default' => '0',
        'type' => 'leaf'
      },
      'MinFontFaceSize',
      {
        'value_type' => 'uniline',
        'default' => '7x12',
        'type' => 'leaf',
        'description' => 'minimum size in pixels in which fonts should be rendered'
      },
      'ShowBigBorder',
      {
        'value_type' => 'uniline',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'border within the usable text area,
for setting up TextResolution and
MinFontFaceSize (if using FT2);
border around the unused area'
      },
      'FontFile',
      {
        'value_type' => 'uniline',
        'default' => '/usr/share/fonts/corefonts/courbd.ttf',
        'type' => 'leaf',
        'description' => 'path to font file to use'
      },
      'UseFT2',
      {
        'value_type' => 'uniline',
        'default' => 'yes',
        'type' => 'leaf',
        'description' => 'no=use graphlcd bitmap fonts (they have only one size / font file)
yes=use fonts supported by FreeType2 (needs Freetype2 support in
libglcdprocdriver and its dependants)'
      },
      'ShowThinBorder',
      {
        'value_type' => 'uniline',
        'default' => 'yes',
        'type' => 'leaf',
        'description' => 'border around the unused area'
      },
      'Backlight',
      {
        'value_type' => 'uniline',
        'default' => 'no',
        'type' => 'leaf',
        'description' => 'Backlight if applicable'
      },
      'Driver',
      {
        'value_type' => 'uniline',
        'upstream_default' => 'image',
        'type' => 'leaf',
        'description' => 'which graphical display supported by graphlcd-base to use 
(see /etc/graphlcd.conf for possible drivers)'
      }
    ]
  }
]
;

