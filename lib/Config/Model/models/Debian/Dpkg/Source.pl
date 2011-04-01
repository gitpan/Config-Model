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
    'read_config' => [
      {
        'auto_create' => '1',
        'backend' => 'PlainFile',
        'config_dir' => 'debian/source'
      }
    ],
    'name' => 'Debian::Dpkg::Source',
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'author' => [
      'Dominique Dumont'
    ],
    'license' => 'LGPL2',
    'element' => [
      'format',
      {
        'value_type' => 'enum',
        'mandatory' => '1',
        'type' => 'leaf',
        'choice' => [
          '1.0',
          '2.0',
          '3.0 (native)',
          '3.0 (quilt)',
          '3.0 (custom)',
          '3.0 (git)',
          '3.0 (bzr)'
        ]
      }
    ]
  }
]
;

