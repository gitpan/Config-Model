#
# This file is part of Config-Model
#
# This software is Copyright (c) 2011 by Dominique Dumont, Krzysztof Tyszecki.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
  {
    'name' => 'LCDd::lis',
    'element' => [
      'Brightness',
      {
        'value_type' => 'integer',
        'min' => '0',
        'upstream_default' => '1000',
        'max' => '1000',
        'type' => 'leaf',
        'description' => 'Set the initial brightness [default: 1000; legal: 0 - 1000]
0-250 = 25%, 251-500 = 50%, 501-750 = 75%, 751-1000 = 100%'
      },
      'Size',
      {
        'value_type' => 'uniline',
        'upstream_default' => '20x2',
        'type' => 'leaf',
        'description' => 'Columns by lines [default: 20x2]'
      },
      'VendorID',
      {
        'value_type' => 'uniline',
        'upstream_default' => '0x0403',
        'type' => 'leaf',
        'description' => 'USB Vendor ID [default: 0x0403]
Change only if testing a compatible device.'
      },
      'ProductID',
      {
        'value_type' => 'uniline',
        'upstream_default' => '0x6001',
        'type' => 'leaf',
        'description' => 'USB Product ID [default: 0x6001]
Change only if testing a compatible device.'
      }
    ]
  }
]
;
