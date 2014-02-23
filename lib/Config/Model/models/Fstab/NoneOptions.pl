#
# This file is part of Config-Model
#
# This software is Copyright (c) 2014 by Dominique Dumont.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
  {
    'class_description' => 'Options for special file system like \'bind\'',
    'name' => 'Fstab::NoneOptions',
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'author' => [
      'Dominique Dumont'
    ],
    'license' => 'LGPL2',
    'element' => [
      'bind',
      {
        'value_type' => 'boolean',
        'type' => 'leaf'
      }
    ]
  }
]
;

