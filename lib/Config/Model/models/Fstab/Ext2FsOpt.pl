#
# This file is part of Config-Model
#
# This software is Copyright (c) 2013 by Dominique Dumont.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
[
  {
    'accept' => [
      '.*',
      {
        'value_type' => 'uniline',
        'type' => 'leaf',
        'description' => 'unknown parameter'
      }
    ],
    'name' => 'Fstab::Ext2FsOpt',
    'include' => [
      'Fstab::CommonOptions'
    ],
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'author' => [
      'Dominique Dumont'
    ],
    'license' => 'LGPL2',
    'element' => [
      'acl',
      {
        'value_type' => 'boolean',
        'type' => 'leaf'
      },
      'user_xattr',
      {
        'value_type' => 'boolean',
        'type' => 'leaf',
        'description' => 'Support "user." extended attributes '
      },
      'statfs_behavior',
      {
        'value_type' => 'enum',
        'type' => 'leaf',
        'choice' => [
          'bsddf',
          'minixdf'
        ]
      },
      'errors',
      {
        'value_type' => 'enum',
        'type' => 'leaf',
        'choice' => [
          'continue',
          'remount-ro',
          'panic'
        ]
      }
    ]
  }
]
;

